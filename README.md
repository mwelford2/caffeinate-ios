# Caffeinate

A tiny iPhone/iPad app that keeps your device awake — like the `caffeinate`
command on a Mac. One button. Nothing else to configure.

It also adds Shortcuts actions so you can automate it, e.g. keep the screen
on automatically whenever a certain app is open.

## Install (AltStore / SideStore / Feather)

1. Copy this source URL:

   ```
   https://raw.githubusercontent.com/mwelford2/caffeinate-ios/main/altstore-source.json
   ```

2. In your sideloading app, add it as a source:
   - **AltStore / SideStore:** Browse → Sources → **+** → paste the URL
   - **Feather:** Sources → **+** → paste the URL
3. Open the source and install **Caffeinate**.

The app is unsigned; your sideloading app signs it with your own Apple ID on
install. iOS 17 or later.

### Manual install

Download `Caffeinate.ipa` from the [latest release](../../releases/latest)
and sideload it however you normally do.

## Using it

- **Tap the cup** to keep the device awake. Tap again to allow it to sleep.
- **Dim screen while awake** (optional toggle) lowers brightness to save
  battery while the screen is held on.

## Keep awake only while a specific app is open

iOS won't let one app watch another, but the Shortcuts app can:

1. Shortcuts app → **Automation** → **+**
2. **App** → pick the app → **Is Opened** → turn off *Ask Before Running*
3. Add action **Keep Device Awake**
4. Make a second automation for the same app with **Is Closed** → action
   **Allow Device to Sleep**

Shortcuts actions included: Keep Device Awake, Allow Device to Sleep,
Toggle Keep Device Awake, Is Device Being Kept Awake.

## Build from source

```
cd Caffeinate
./build-ipa.sh
```

Produces `build/Caffeinate.ipa` (unsigned).
