#!/bin/bash
# Builds an unsigned Caffeinate.ipa suitable for AltStore / SideStore / Feather.
# The sideloading app re-signs it on-device with the user's Apple ID.
set -euo pipefail

cd "$(dirname "$0")"

DERIVED="build"
PRODUCTS="$DERIVED/Build/Products/Release-iphoneos"

rm -rf "$DERIVED"

xcodebuild \
  -project Caffeinate.xcodeproj \
  -scheme Caffeinate \
  -configuration Release \
  -sdk iphoneos \
  -derivedDataPath "$DERIVED" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  build

cd "$PRODUCTS"
rm -rf Payload Caffeinate.ipa
mkdir Payload
cp -R Caffeinate.app Payload/
zip -qr Caffeinate.ipa Payload
rm -rf Payload

DEST="../../../Caffeinate.ipa"
mv Caffeinate.ipa "$DEST"
cd - >/dev/null

VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" \
  "$PRODUCTS/Caffeinate.app/Info.plist")
echo
echo "Built build/Caffeinate.ipa  (version $VERSION, unsigned)"
