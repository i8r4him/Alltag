#!/usr/bin/env python3
"""Makes the natural voice of the app's fixed German once, ahead of time (#422).

Reads the word collections (each example sentence, and each word with its article, which Memory
speaks) and the grammar rules' sentences from the Swift content files, splits them into
sentences the way the app does (`SpeechChunks`), and sends them to the `speak-warm` function,
which makes only what the shared cache doesn't have yet. Run it again after adding content.

    caffeinate -i python3 scripts/warm_speech.py   # make what's missing (8 a minute: hours for all)
    python3 scripts/warm_speech.py --list           # only count the texts, send nothing

The token comes from `ALLTAG_WARM_TOKEN` or the file `.warm_token` next to this repo's README
(ignored by git).

The token's SHA-256 is `WARM_TOKEN_SHA256` in `supabase/functions/speak-warm/index.ts`. To warm
again, make a new token (`python3 -c "import secrets; print(secrets.token_hex(32))"`), put its
hash there and deploy the function.
"""
import glob
import json
import os
import re
import sys
import time
import urllib.error
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
URL = "https://flbymqlcauvwumznvviq.supabase.co/functions/v1/speak-warm"
BATCH = 8
# Gemini allows 10 requests a minute for the TTS model on Tier 1, shared with the app's own
# requests: one batch of 8 a minute leaves room for them.
MINUTE = 60
LIMIT = 280  # SpeechChunks.limit
ABBREVIATIONS = {"z.", "B.", "Dr.", "Nr.", "usw.", "ca.", "bzw.", "Str.", "Hr.", "Fr.", "d.", "h.", "u.", "a."}


def literal(source, index):
    """Reads the Swift string literal that starts at source[index] == '"'."""
    index += 1
    out = []
    while source[index] != '"':
        if source[index] == "\\":
            escaped = source[index + 1]
            if escaped == "u":
                end = source.index("}", index)
                out.append(chr(int(source[index + 3:end], 16)))
                index = end + 1
                continue
            out.append({"n": "\n", "t": "\t", '"': '"', "\\": "\\", "'": "'"}[escaped])
            index += 2
            continue
        out.append(source[index])
        index += 1
    return "".join(out), index + 1


def literals(source, index, count):
    values = []
    while len(values) < count:
        while source[index] in " \n\t,":
            index += 1
        value, index = literal(source, index)
        values.append(value)
    return values


def fixed_texts():
    """The grammar rules' sentences first, then the collections' examples, then their words."""
    rules, examples, words = [], [], []
    for path in sorted(glob.glob(f"{ROOT}/Alltag/MockData/MockRules*.swift")):
        source = open(path, encoding="utf-8").read()
        for match in re.finditer(r"^        german: ", source, re.M):
            rules.append(literal(source, match.end())[0])
    for path in sorted(glob.glob(f"{ROOT}/Alltag/Features/Learn/Collections/Content/*.swift")):
        source = open(path, encoding="utf-8").read()
        for match in re.finditer(r"CollectionWord\(", source):
            article, word, _, example, _ = literals(source, match.end(), 5)
            examples.append(example)
            words.append(article + word)
    return rules + examples + words


def sentences(text):
    """Close to the app's NLTokenizer split: a sentence ends at . ! ? before a capital letter,
    except after a number or a common abbreviation. A rare mismatch only means that sentence
    is made on its first real use instead."""
    words = text.split()
    out, current = [], []
    for position, word in enumerate(words):
        current.append(word)
        following = words[position + 1] if position + 1 < len(words) else ""
        ends = re.search(r"[.!?…][\"“”„‘’)]*$", word) and following[:1].isupper()
        if ends and word not in ABBREVIATIONS and not re.fullmatch(r"\d+\.", word):
            out.append(" ".join(current))
            current = []
    if current:
        out.append(" ".join(current))
    pieces = []
    for sentence in out:
        if len(sentence) <= LIMIT:
            pieces.append(sentence)
            continue
        piece = ""
        for word in sentence.split(" "):
            candidate = f"{piece} {word}" if piece else word
            if len(candidate) > LIMIT and piece:
                pieces.append(piece)
                piece = word[:LIMIT]
            else:
                piece = candidate[:LIMIT]
        if piece:
            pieces.append(piece)
    return pieces


def send(texts, token):
    request = urllib.request.Request(URL, data=json.dumps({"texts": texts}).encode(), method="POST",
                                     headers={"Content-Type": "application/json", "X-Warm-Token": token})
    with urllib.request.urlopen(request, timeout=150) as response:
        return json.load(response)


def main():
    unique = list(dict.fromkeys(piece for text in fixed_texts() for piece in sentences(" ".join(text.split()))))
    print(f"{len(unique)} sentences, {sum(map(len, unique))} characters")
    if "--list" in sys.argv:
        return
    token = os.environ.get("ALLTAG_WARM_TOKEN")
    token_file = os.path.join(ROOT, ".warm_token")
    if not token and os.path.exists(token_file):
        token = open(token_file, encoding="utf-8").read().strip()
    if not token:
        sys.exit("Set ALLTAG_WARM_TOKEN or put the token in .warm_token.")
    made = had = 0
    failed = []
    for start in range(0, len(unique), BATCH):
        batch = unique[start:start + BATCH]
        began = time.monotonic()
        for attempt in range(4):
            try:
                result = send(batch, token)
                break
            except (urllib.error.URLError, TimeoutError) as error:
                print(f"  retrying after {error}")
                time.sleep(10 * (attempt + 1))
        else:
            failed += batch
            continue
        made += result["made"]
        had += result["had"]
        failed += result["failed"]
        print(f"{start + len(batch)}/{len(unique)}: made {made}, had {had}, failed {len(failed)}", flush=True)
        if result["made"] or result["failed"]:
            time.sleep(max(0, MINUTE - (time.monotonic() - began)))
    print(f"Done: made {made}, had {had}, failed {len(failed)}")
    if failed:
        print("Failed (run again to retry):", *failed[:20], sep="\n  ")


if __name__ == "__main__":
    main()
