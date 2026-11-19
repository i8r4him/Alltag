#!/usr/bin/env bash
# Builds the app and updates the String Catalogs (Localizable and
# AppShortcuts) from the code, like Xcode
# does when you build in the IDE: adds new strings, removes unused ones (only
# those without translations) and sorts keys case-insensitively.
#
# Usage: scripts/sync_string_catalog.sh
set -euo pipefail
cd "$(dirname "$0")/.."

derived="DerivedData"
catalogs=(Alltag/Resources/Localizable.xcstrings Alltag/Resources/AppShortcuts.xcstrings)

xcodebuild build -project Alltag.xcodeproj -scheme Alltag \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath "$derived" CODE_SIGNING_ALLOWED=NO -quiet

stringsdata=()
while IFS= read -r -d '' file; do stringsdata+=(--stringsdata "$file"); done \
  < <(find "$derived" -name "*.stringsdata" \( -path "*/Debug-iphonesimulator/Alltag.build/Objects-normal/*" -o -path "*/Debug-iphonesimulator/AlltagTranslation.build/Objects-normal/*" -o -path "*/Debug-iphonesimulator/AlltagShare.build/Objects-normal/*" \) -print0)
for catalog in "${catalogs[@]}"; do
xcrun xcstringstool sync "$catalog" "${stringsdata[@]}"

python3 -I - "$catalog" <<'EOF'
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as file:
    data = json.load(file)
strings = data["strings"]
# Stale keys without translations carry nothing worth keeping.
removed = [key for key, value in strings.items()
           if value.get("extractionState") == "stale" and not value.get("localizations")]
for key in removed:
    del strings[key]
data["strings"] = dict(sorted(strings.items(), key=lambda item: item[0].lower()))
with open(path, "w", encoding="utf-8") as file:
    file.write(json.dumps(data, indent=2, ensure_ascii=False).replace('": ', '" : ') + "\n")
print(f"{path}: {len(data['strings'])} keys, removed {len(removed)} unused")
EOF
done
