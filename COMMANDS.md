
## Add Flavor Script Commands

### Add New Flavor (Template)

```bash
dart run scripts/add_flavor.dart --name <flavor-name> --arabic "<Arabic Name>" --english "<English Name>" --type surah --app-id com.ummeshuja.<flavor-name> --banner-id <admob-banner-unit-id> --admob-app-id <admob-app-id>
```

### Add Surah Yaseen

```bash

dart run scripts/add_flavor.dart --name surah_yaseen --arabic "سورۃ یٰسٓ" --english "Surah Yaseen" --type surah --app-id com.ummeshuja.surahyaseen.mp3 --banner-id <admob-banner-unit-id> --admob-app-id <admob-app-id>
```

### Add Surah Rahman

```bash
dart run scripts/add_flavor.dart --name surah_rehman --arabic "سورۃ الرَّحْمَن" --english "Surah Rahman" --type surah --app-id com.ummeshuja.surahrehman.mp3 --banner-id <admob-banner-unit-id> --admob-app-id <admob-app-id>
```

### Add Surah Mulk

```bash
dart run scripts/add_flavor.dart --name surah_mulk --arabic "سورۃ الْمُلْک" --english "Surah Mulk" --type surah --app-id com.ummeshuja.surahmulk.mp3 --banner-id <admob-banner-unit-id> --admob-app-id <admob-app-id>
```

### Add Surah Muzammil

```bash
dart run scripts/add_flavor.dart --name surah_muzammil --arabic "سورة المزمل" --english "Surah Muzammil" --type surah --app-id com.ummeshuja.surahmuzammil.mp3 --banner-id <admob-banner-unit-id> --admob-app-id <admob-app-id>
```
<!-- test ids -->
```bash
dart run scripts/add_flavor.dart --name surah_muzammil --arabic "سورة المزمل" --english "Surah Muzammil" --type surah --app-id com.ummeshuja.surahmuzammil.mp3 --banner-id ca-app-pub-3940256099942544/6300978111 --admob-app-id ca-app-pub-3940256099942544~3347511713
```

### Add <name of flavor>

```bash
dart run scripts/add_flavor.dart --name <flavor-name> --arabic "<Arabic Name>" --english "<English Name>" --type surah --app-id com.ummeshuja.<flavor-name> --banner-id <admob-banner-unit-id> --admob-app-id <admob-app-id>
```

> **Note**: `--banner-id` and `--admob-app-id` are optional. If omitted, placeholder IDs are written — edit `lib/secrets/secrets.dart` and `android/app/admob.properties` manually after.

---

## Running the App

> **Important**: This is now an **Audio Player App** (not PDF Viewer). Make sure you have audio files in `assets/islamic_content/` directory named as `{flavor}.mp3` (e.g., `surah_yaseen.mp3`, `surah_muzammil.mp3`).

### Run Surah Yaseen

```bash
flutter run --flavor surah_yaseen --dart-define=FLAVOR=surah_yaseen
```

### Run Surah Rahman

```bash
flutter run --flavor surah_rehman --dart-define=FLAVOR=surah_rehman
```

### Run Surah Mulk

```bash
flutter run --flavor surah_mulk --dart-define=FLAVOR=surah_mulk
```

### Run Surah Muzammil

```bash
flutter run --flavor surah_muzammil --dart-define=FLAVOR=surah_muzammil 
```

### Run in Release Mode

```bash
flutter run --flavor surah_yaseen --dart-define=FLAVOR=surah_yaseen --release
```

### List Available Devices

```bash
flutter devices
```

### Run on Specific Device

```bash
flutter run --flavor surah_yaseen --dart-define=FLAVOR=surah_yaseen -d <device-id>
```

---

## Building for Release

### Build APK (Release)

```bash
flutter build apk --flavor surah_yaseen --dart-define=FLAVOR=surah_yaseen --release
flutter build apk --flavor surah_rehman --dart-define=FLAVOR=surah_rehman --release
flutter build apk --flavor surah_mulk --dart-define=FLAVOR=surah_mulk --release
```

### Build App Bundle for Google Play (Release)

```bash
flutter build appbundle --flavor surah_yaseen --dart-define=FLAVOR=surah_yaseen --release
flutter build appbundle --flavor surah_rehman --dart-define=FLAVOR=surah_rehman --release
flutter build appbundle --flavor surah_mulk --dart-define=FLAVOR=surah_mulk --release
```

> **Output path**: `build/app/outputs/bundle/<flavor>Release/app-<flavor>-release.aab`

---

## Important Notes - Audio Player App

### Audio Asset Structure

Your `assets/islamic_content/` directory should contain:
```
assets/
  islamic_content/
  surah_yaseen/
      surah_yaseen.mp3
      surah_yaseen_icon.png
      ...
```

### AppConfig Changes

The `AppConfig` class now requires an `audio` parameter that specifies the audio file path:

```dart
const AppConfig(
  nameArabic: 'سورۃ یٰسٓ',
  nameEnglish: 'Surah Yaseen',
  admobBannerUnitId: Secrets.surahYaseenBannerUnitId,
  contentType: ContentType.surah,
);
```

### Dependencies Changed

**Removed:**
- `syncfusion_flutter_pdfviewer: ^33.1.46`

**Added:**
- `audioplayers: ^6.0.0`

### PlayerScreen Widget

The main screen is now `PlayerScreen` (previously `PdfViewerScreen`) with the following features:
- ▶️ Play/Pause button with circular avatar design
- ⏱️ Progress slider with seek functionality
- ⏲️ Time display (current position / total duration)
- 🎨 Green gradient header matching Islamic theme
- 📱 AdMob banner ad integration
- 📊 Duration and position tracking

---

## Splash Screen

### Generate / Refresh Splash Screen

```bash
flutter pub run flutter_native_splash:create
```

> Splash config is in `pubspec.yaml` under `flutter_native_splash`.

---

## Git

### Tag a Release

```bash
git tag v1.0.0
git push origin v1.0.0
```

### Create Feature Branch

```bash
git checkout -b feature/<branch-name>
```

### Stash Changes

```bash
git stash
git stash pop
```

### View Recent History

```bash
git log --oneline -10
```

---