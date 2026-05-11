
## Add Flavor Script Commands

### Add New Flavor (Template)

```bash
dart run scripts/add_flavor.dart --name <flavor-name> --arabic "<Arabic Name>" --english "<English Name>" --type surah --app-id com.ummeshuja.<flavor-name> --banner-id <admob-banner-unit-id> --admob-app-id <admob-app-id>
```

### Add Surah Yaseen

```bash

dart run scripts/add_flavor.dart --name surah_yaseen --arabic "سورۃ یٰسٓ" --english "Surah Yaseen" --type surah --app-id com.ummeshuja.surahyaseen.pdf --banner-id <admob-banner-unit-id> --admob-app-id <admob-app-id>
```

### Add Surah Rahman

```bash
dart run scripts/add_flavor.dart --name surah_rehman --arabic "سورۃ الرَّحْمَن" --english "Surah Rahman" --type surah --app-id com.ummeshuja.surahrehman.pdf --banner-id <admob-banner-unit-id> --admob-app-id <admob-app-id>
```

### Add Surah Mulk

```bash
dart run scripts/add_flavor.dart --name surah_mulk --arabic "سورۃ الْمُلْک" --english "Surah Mulk" --type surah --app-id com.ummeshuja.surahmulk.pdf --banner-id <admob-banner-unit-id> --admob-app-id <admob-app-id>
```

### Add Surah Muzammil

```bash
dart run scripts/add_flavor.dart --name surah_muzammil --arabic "سورة المزمل" --english "Surah Muzammil" --type surah --app-id com.ummeshuja.surahmuzammil.pdf --banner-id <admob-banner-unit-id> --admob-app-id <admob-app-id>
```

### Add <name of flavor>

```bash
dart run scripts/add_flavor.dart --name <flavor-name> --arabic "<Arabic Name>" --english "<English Name>" --type surah --app-id com.ummeshuja.<flavor-name> --banner-id <admob-banner-unit-id> --admob-app-id <admob-app-id>
```

> **Note**: `--banner-id` and `--admob-app-id` are optional. If omitted, placeholder IDs are written — edit `lib/secrets/secrets.dart` and `android/app/admob.properties` manually after.

---

## Running the App

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

### Clean Before Release Build

```bash
flutter clean && flutter pub get
```

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