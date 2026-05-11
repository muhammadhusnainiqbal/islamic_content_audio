# Islamic Content PDF Viewer

A production-ready **multi-flavor Flutter application** for distributing Islamic content (Surahs, Duas, Ayat etc) as separate branded apps on Play Store & App Store. Each flavor is a distinct app with unique branding, PDF content, and monetization configuration.

## Features

- 📱 **Multi-Flavor Architecture**: Build multiple distinct apps from a single codebase
- 📄 **PDF Viewer**: Fast, gesture-based PDF viewing using Syncfusion
- 🎨 **Per-Flavor Customization**: Unique app names, icons, colors per flavor
- 💰 **AdMob Integration**: Per-flavor AdMob configuration for monetization
- 🤖 **Automated Flavor Scaffolding**: Add new flavors with a single command
- 🔒 **Build-Time Asset Correctness**: Impossible to ship wrong PDF (enforced by Gradle)
- 🔐 **Environment-Based Secrets**: No hardcoded credentials; CI/CD-ready

## Project Structure

```
islamic_content_pdf/
├── lib/
│   ├── main.dart                      # Entry point (FLAVOR routing)
│   ├── config/
│   │   ├── flavor_manager.dart        # Flavor registry
│   │   ├── app_config.dart            # Configuration model
│   │   ├── content_type.dart          # Content type enum
│   │   ├── surah_yaseen_config.dart   # Flavor 1
│   │   ├── surah_rehman_config.dart   # Flavor 2
│   │   └── surah_mulk_config.dart     # Flavor 3
│   ├── screens/
│   │   └── pdf_viewer_screen.dart     # Main UI
│   ├── secrets/
│   │   └── secrets.dart               # AdMob IDs (Git-ignored)
│   └── theme/
│       └── app_theme.dart             # Material theme
├── android/
│   └── app/
│       ├── build.gradle.kts           # Gradle config + flavors
│       ├── admob.properties           # AdMob IDs (Git-ignored)
│       └── src/main/AndroidManifest.xml
├── assets/
│   ├── islamic_content/               # Runtime asset (PDF)
│   ├── icons/                         # Runtime icon
│   ├── surah_yaseen/                  # Flavor 1 source
│   ├── surah_rehman/                  # Flavor 2 source
│   ├── surah_mulk/                    # Flavor 3+ source
│   └── splash/                        # Splash screen
├── scripts/
│   └── add_flavor.dart                # Flavor scaffolder
├── test/
│   └── widget_test.dart
├── pubspec.yaml                       # Flutter config
├── analysis_options.yaml              # Linter rules
├── COMMANDS.md                        # All copy-paste commands
└── README.md                          # This file
```

## Prerequisites

- **Flutter**: 3.10.7 or later ([install](https://flutter.dev/docs/get-started/install))
- **Dart**: 3.10.7+ (bundled with Flutter)
- **Android Studio** (for Android development)
- **Git**: For version control

## Setup & Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd islamic_content_pdf
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Verify Setup

```bash
flutter doctor
```

Ensure all required components show ✓.

## Running the App

### Run Default Flavor (surah_yaseen)

```bash
flutter run
```

### Run Specific Flavor

```bash
flutter run --flavor <flavor-name> --dart-define=FLAVOR=<flavor-name>
```

**Examples:**

```bash
# Surah Yaseen
flutter run --flavor surah_yaseen --dart-define=FLAVOR=surah_yaseen

# Surah Rahman
flutter run --flavor surah_rehman --dart-define=FLAVOR=surah_rehman

# Surah Mulk
flutter run --flavor surah_mulk --dart-define=FLAVOR=surah_mulk
```

## Building

### Build APK (Release)

```bash
flutter build apk --flavor <flavor-name> --dart-define=FLAVOR=<flavor-name> --release
```

Output: `build/app/outputs/apk/<flavor-name>/release/app-<flavor-name>-release.apk`

### Build App Bundle (for Google Play)

```bash
flutter build appbundle --flavor <flavor-name> --dart-define=FLAVOR=<flavor-name> --release
```

Output: `build/app/outputs/bundle/<flavor-name>Release/app-<flavor-name>-release.aab`

## Multi-Flavor Architecture

### What is a Flavor?

Each flavor is a distinct app configuration:
- **Unique App ID**: `com.ummeshuja.<flavor-name>` (separate Play Store listing)
- **Custom Branding**: Name, icon, colors, splash screen
- **Dedicated Content**: Own PDF file
- **AdMob Configuration**: Per-flavor monetization

### Existing Flavors

| Flavor | English Name | App ID |
|--------|--------------|--------|
| `surah_yaseen` | Surah Yaseen | `com.ummeshuja.surahyaseen.pdf` |
| `surah_rehman` | Surah Rahman | `com.ummeshuja.surahrehman.pdf` |
| `surah_mulk` | Surah Mulk | `com.ummeshuja.surahmulk.pdf` |

### How Flavors Work

1. **Build Selection**: `flutter build ... --flavor surah_yaseen` selects the flavor
2. **Asset Pipeline**: Gradle copies `assets/surah_yaseen/surah_yaseen.pdf` → `assets/islamic_content/islamic_content.pdf`
3. **Dart Configuration**: `--dart-define=FLAVOR=surah_yaseen` tells the app which config to use
4. **Runtime Routing**: `FlavorManager.getConfig('surah_yaseen')` returns the correct `AppConfig`
5. **Output**: Separate APK with correct content, icon, and monetization

**Result**: Each flavor is a complete, standalone app (~30-50MB per flavor).

## Adding a New Flavor

### Prerequisites

Before running the script, prepare:

1. **PDF File**: `assets/<flavor-name>/<flavor-name>.pdf` (your Islamic content)
2. **Icon**: `assets/<flavor-name>/<flavor-name>_icon.png` (1024×1024 PNG)

### Step 1: Place Assets

```bash
# Create flavor directory
mkdir -p assets/<flavor-name>

# Copy your PDF
cp your_content.pdf assets/<flavor-name>/<flavor-name>.pdf

# Copy your icon
cp icon.png assets/<flavor-name>/<flavor-name>_icon.png
```

### Step 2: Run Flavor Scaffolder

See [COMMANDS.md](COMMANDS.md) for ready-to-copy commands including Arabic names.

```bash
dart run scripts/add_flavor.dart \
  --name <flavor-name> \
  --arabic "<Arabic Name>" \
  --english "<English Name>" \
  --type surah \
  --app-id com.ummeshuja.<flavor-name> \
  --banner-id <admob-banner-unit-id> \
  --admob-app-id <admob-app-id>
```

> `--banner-id` and `--admob-app-id` are optional. Omit them to write placeholder IDs and fill in later.

### What the Script Does

1. ✅ Creates `lib/config/<flavor-name>_config.dart`
2. ✅ Registers in `lib/config/flavor_manager.dart`
3. ✅ Adds AdMob banner ID to `lib/secrets/secrets.dart`
4. ✅ Adds productFlavor to `android/app/build.gradle.kts`
5. ✅ Adds AdMob app ID to `android/app/admob.properties`
6. ✅ Generates launcher icons for all platforms
7. ✅ Copies assets to runtime locations

### Step 3: Test the New Flavor

```bash
flutter run --flavor <flavor-name> --dart-define=FLAVOR=<flavor-name>
```

### Step 4: Build Release Bundle

```bash
flutter build appbundle --flavor <flavor-name> --dart-define=FLAVOR=<flavor-name> --release
```

## Android Build System

### Gradle Configuration

The app uses **Kotlin DSL** (`build.gradle.kts`) for Gradle configuration:

- **Flavors**: Each productFlavor has unique `applicationId`, `manifestPlaceholders`, and branding
- **Asset Copy Task**: Gradle copies the correct flavor PDF before asset bundling
- **AdMob Injection**: Per-flavor AdMob app IDs injected into AndroidManifest
- **Signing**: Keystore credentials loaded from environment variables (for CI/CD)

### Key Files

- `android/app/build.gradle.kts`: Flavor definitions, copy task, signing
- `android/app/admob.properties`: AdMob app IDs (Git-ignored, environment-injected)
- `android/app/src/main/AndroidManifest.xml`: App manifest with placeholders

## Secrets & Configuration

### AdMob IDs

The app reads AdMob IDs from:
- `lib/secrets/secrets.dart` — banner unit IDs per flavor (Git-ignored)
- `android/app/admob.properties` — AdMob app IDs per flavor (Git-ignored)

Both files are generated by the `add_flavor.dart` script. For production, inject real IDs via the script's `--banner-id` and `--admob-app-id` flags.

### Keystore & Signing

For production APK/bundle signing:

1. Create keystore (if not exists):
   ```bash
   keytool -genkey -v -keystore android/app/keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias <key-alias> -storepass <store-password>
   ```

2. Set environment variables:
   ```bash
   export KEYSTORE_PATH="/path/to/keystore.jks"
   export KEYSTORE_PASSWORD="store-password"
   export KEY_ALIAS="key-alias"
   export KEY_PASSWORD="key-password"
   ```

3. Build with signing:
   ```bash
   flutter build appbundle --flavor <flavor-name> --dart-define=FLAVOR=<flavor-name> --release
   ```

## Release & Deployment

### Release Checklist

- ✅ Increment version in `pubspec.yaml` (e.g., `1.0.1+2`)
- ✅ Test all flavors locally
- ✅ Verify PDF loads correctly
- ✅ Check AdMob banner visibility
- ✅ Build release APK/bundle
- ✅ Test release build on device
- ✅ Verify app signing

### Upload to Google Play Console

1. Log in to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Navigate to **Release** → **Production** (or **Internal Testing** first)
4. Upload the `.aab` file from `build/app/outputs/bundle/<flavor-name>Release/`
5. Review app info, screenshots, and permissions
6. Submit for review

## Project Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `syncfusion_flutter_pdfviewer` | ^33.1.46 | PDF viewing |
| `google_mobile_ads` | ^7.0.0 | AdMob integration |
| `flutter_native_splash` | ^2.4.0 | Splash screen |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |
| `flutter_launcher_icons` | ^0.14.4 | Icon generation |
| `flutter_lints` | ^6.0.0 | Code linting |

