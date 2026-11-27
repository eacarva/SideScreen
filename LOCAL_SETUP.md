# Local setup (backup branch, not for upstream)

Personal build of SideScreen for an MT6592 tablet (Android 5.1) on a Hackintosh
without a hardware H.264 encoder. Upstream PRs carry the generic parts:
tranvuongquocdat/SideScreen#124 to #128.

## Extra in this branch

- `displayChangedHook`: a shell command (defaults key `SideScreen_displayChangedHook`)
  run 2 s after the virtual display is created or removed. Used to restore a
  BetterDisplay mirror that macOS breaks when displays change.
- Clean quit on SIGTERM so the display is torn down and the hook runs.
- `scripts/sign_local.sh`: re-sign with a local trusted certificate
  ("SideScreen Local Signing") so Screen Recording / Accessibility grants
  survive rebuilds.
- `build_mac.sh` uses `pkill -x` (a `pkill -f SideScreen` also killed the shell running it).
- Extra logging: first touches, encoded frames, encoder failures.

## Rebuild and install

```bash
./scripts/build_mac.sh && ./scripts/sign_local.sh
osascript -e 'quit app "SideScreen"'; rm -rf /Applications/SideScreen.app && mv SideScreen.app /Applications/
```

Android (JDK 21, SDK path in `AndroidClient/local.properties`):

```bash
cd AndroidClient && ./gradlew installDebug
```

Needs `brew install x264` for the x264 path.

## Preferences (com.sidescreen.app)

```bash
defaults write com.sidescreen.app SideScreen_autoStartStreamingOnLaunch -bool true
defaults write com.sidescreen.app SideScreen_startupMode -string usb
defaults write com.sidescreen.app SideScreen_connectionMode -string usb
defaults write com.sidescreen.app SideScreen_bitrate -int 40
defaults write com.sidescreen.app SideScreen_resolution -string 1680x1050
defaults write com.sidescreen.app SideScreen_hiDPI -bool false
defaults write com.sidescreen.app SideScreen_displayChangedHook -string '/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay set -tagID=15 -mirror=on -targetTagID=2'
```

The tablet also has a per-device profile (`devices.profiles`) that overrides
resolution on connect: change resolution in the app's settings while the
tablet is connected so the profile is updated too.
