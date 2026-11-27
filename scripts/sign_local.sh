#!/bin/bash
# Re-sign SideScreen.app with the local "SideScreen Local Signing" certificate so
# macOS keeps the Screen Recording / Accessibility grants across rebuilds.
set -euo pipefail
cd "$(dirname "$0")/.."
F=(--force --options runtime --sign "SideScreen Local Signing")
S=SideScreen.app/Contents/Frameworks/Sparkle.framework
for x in Versions/B/XPCServices/Installer.xpc Versions/B/XPCServices/Downloader.xpc Versions/B/Autoupdate Versions/B/Updater.app; do
  codesign "${F[@]}" --preserve-metadata=entitlements "$S/$x"
done
codesign "${F[@]}" "$S"
codesign "${F[@]}" --entitlements MacHost/SideScreen.entitlements SideScreen.app
xattr -cr SideScreen.app
