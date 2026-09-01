#!/bin/bash
# Cuts a new release: builds the IPA, updates altstore-source.json, tags,
# and publishes a GitHub Release with the IPA attached.
#
# Usage: ./release.sh <version> "<release notes>"
#   e.g. ./release.sh 1.0.1 "Fix landscape layout on iPad."
set -euo pipefail

VERSION="${1:?usage: ./release.sh <version> \"<notes>\"}"
NOTES="${2:?usage: ./release.sh <version> \"<notes>\"}"
REPO="mwelford2/caffeinate-ios"
DATE=$(date -u +%Y-%m-%d)

cd "$(dirname "$0")"

# 1. Bump MARKETING_VERSION in the project.
sed -i '' "s/MARKETING_VERSION = [^;]*;/MARKETING_VERSION = $VERSION;/g" \
  Caffeinate/Caffeinate.xcodeproj/project.pbxproj

# 2. Build the unsigned IPA.
( cd Caffeinate && ./build-ipa.sh )
IPA="Caffeinate/build/Caffeinate.ipa"
SIZE=$(stat -f%z "$IPA")

# 3. Prepend a new version entry to altstore-source.json.
python3 - "$VERSION" "$DATE" "$NOTES" "$SIZE" <<'PY'
import json, sys
version, date, notes, size = sys.argv[1:5]
path = "altstore-source.json"
with open(path) as f:
    src = json.load(f)
app = src["apps"][0]
entry = {
    "version": version,
    "date": date,
    "localizedDescription": notes,
    "downloadURL": f"https://github.com/mwelford2/caffeinate-ios/releases/download/v{version}/Caffeinate.ipa",
    "size": int(size),
    "minOSVersion": "17.0",
}
app["versions"] = [entry] + [v for v in app["versions"] if v["version"] != version]
with open(path, "w") as f:
    json.dump(src, f, indent=2)
    f.write("\n")
PY

# 4. Update CHANGELOG.
TMP=$(mktemp)
{
  echo "# Changelog"
  echo
  echo "## $VERSION — $DATE"
  echo
  echo "$NOTES"
  echo
  tail -n +2 CHANGELOG.md
} > "$TMP"
mv "$TMP" CHANGELOG.md

# 5. Commit, tag, push.
git add -A
git commit -m "Release v$VERSION"
git tag "v$VERSION"
git push origin main --tags

# 6. GitHub Release with the IPA attached.
gh release create "v$VERSION" "$IPA" \
  --repo "$REPO" \
  --title "v$VERSION" \
  --notes "$NOTES"

echo
echo "Released v$VERSION. Source auto-updates for anyone who added it."
