#!/bin/sh
#
#  ci_post_xcodebuild.sh
#  Alltag
#
#  Xcode Cloud runs this after each xcodebuild action. After the TestFlight archive it writes
#  TestFlight's "What to Test" from the commits on main since the previous testflight-* tag,
#  so testers see what changed. Xcode Cloud reads TestFlight/WhatToTest.<locale>.txt in the
#  repository root. Nothing here may stop the upload, so every step is allowed to fail.
#

# Only after an archive signed for App Store Connect, not after a plain build.
if [ ! -d "${CI_APP_STORE_SIGNED_APP_PATH:-}" ]; then
    exit 0
fi

cd "$CI_PRIMARY_REPOSITORY_PATH" || exit 0

# Xcode Cloud clones only the newest commits; fetch the history and the tags.
git fetch --unshallow --tags --quiet 2>/dev/null || git fetch --tags --quiet 2>/dev/null

previous=$(git describe --tags --abbrev=0 --match 'testflight-*' HEAD^ 2>/dev/null)
if [ -n "$previous" ]; then
    changes=$(git log --first-parent --format='- %s' "$previous..HEAD" 2>/dev/null | head -n 30)
else
    changes=$(git log --first-parent --format='- %s' -n 10 2>/dev/null)
fi

notes_dir="$CI_PRIMARY_REPOSITORY_PATH/TestFlight"
mkdir -p "$notes_dir"
{
    echo "Build ${CI_BUILD_NUMBER:-?} from ${CI_TAG:-main} ($(git rev-parse --short HEAD 2>/dev/null))"
    echo
    echo "What changed:"
    echo "$changes"
} | head -c 3900 > "$notes_dir/WhatToTest.en-US.txt"
cp "$notes_dir/WhatToTest.en-US.txt" "$notes_dir/WhatToTest.en-GB.txt"

echo "What to Test:"
cat "$notes_dir/WhatToTest.en-US.txt"
exit 0
