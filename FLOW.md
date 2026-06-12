# Screenshot capture flow

Real captures from the iOS Simulator via an integration-test driver (no mockups).

## Steps

1. Boot the simulator:
   ```bash
   xcrun simctl boot "iPhone 17"
   open -a Simulator
   ```
2. Scaffold the iOS platform folder (lib-only project) and get dependencies:
   ```bash
   flutter create . --platforms=ios --project-name flutter_pet_health
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```
3. Drive the screenshot test:
   ```bash
   flutter drive \
     --driver test_driver/integration_test.dart \
     --target integration_test/screenshot_test.dart \
     -d "iPhone 17"
   ```
4. Build the demo GIF from the PNGs:
   ```bash
   cd screenshots
   ffmpeg -y -framerate 1 -pattern_type glob -i '*.png' \
     -vf "scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
     -loop 0 demo.gif
   ```

PNGs + `demo.gif` are written to `screenshots/` and embedded in `README.md`.

## How it works

- `test_driver/integration_test.dart` - `integrationDriver(onScreenshot:)` writes each PNG to `screenshots/<name>.png`.
- `integration_test/screenshot_test.dart` - in `setUpAll` it calls `Hive.initFlutter()`, registers the generated adapters, opens the `pets` / `health_records` / `routines` boxes, and seeds three pets (Luna, Milo, Kiwi) plus a set of Luna's health records (vaccination, weight, vet visit, medication) so the screens render real-looking content. The test then:
  1. Pumps `PetListScreen` inside a `ProviderScope` and shoots `01-pet-list`.
  2. Taps the `Luna` row to open `PetDetailScreen` (profile header + health-record timeline) and shoots `02-pet-profile`.
  3. Taps `Add`, fills the title and notes fields on `AddHealthRecordScreen`, and shoots `03-add-health-record`.
- Each shot calls `binding.convertFlutterSurfaceToImage()` + `pumpAndSettle()` + `binding.takeScreenshot('NN-name')`.
