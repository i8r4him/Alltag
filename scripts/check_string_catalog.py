#!/usr/bin/env python3
"""Fail if a String Catalog is out of date with the code.

Usage: check_string_catalog.py <committed.xcstrings> <synced.xcstrings>

<synced> is a copy of <committed> after `xcrun xcstringstool sync` with the
build's .stringsdata files. The copy must keep the original file name: the
table name comes from it. The check compares contents, not key order, so
Xcode and xcstringstool can each sort keys their own way.
"""
import json
import re
import sys


def load(path):
    with open(path, encoding="utf-8") as file:
        return json.load(file)["strings"]


def main():
    committed, synced = load(sys.argv[1]), load(sys.argv[2])
    missing = sorted(set(synced) - set(committed), key=str.lower)
    # Unused keys are either marked stale or dropped by sync, depending on
    # whether they have translations. Keys marked manual are kept on purpose.
    dropped = (key for key in set(committed) - set(synced)
               if committed[key].get("extractionState") != "manual")
    marked = (key for key, value in synced.items() if value.get("extractionState") == "stale")
    stale = sorted(set(dropped) | set(marked), key=str.lower)
    # Keys with nothing to translate ("", "%@%@") come from interpolating
    # content into Text; use Text(verbatim:) or an AttributedString instead.
    # Keys explicitly marked shouldTranslate: false are allowed.
    empty = sorted(
        key for key, value in synced.items()
        if not re.sub(r"%(\d+\$)?(@|lld|d|f)", "", key).strip() and value.get("shouldTranslate") is not False
    )
    if empty:
        print("String Catalog has keys with nothing to translate:")
        for key in empty:
            print(f"  {key!r}")
        return 1
    if not missing and not stale:
        print(f"String Catalog is up to date ({len(committed)} keys).")
        return 0
    print("String Catalog is out of date. Build in Xcode (or run xcstringstool sync) and commit the catalog.")
    for key in missing:
        print(f"  missing: {key!r}")
    for key in stale:
        print(f"  no longer used: {key!r}")
    return 1


if __name__ == "__main__":
    sys.exit(main())
