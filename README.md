# Islamic Content Audio Player

A production-ready **multi-flavor Flutter application** for distributing Islamic content (Surahs, Duas, Ayat, etc.) as separate branded audio player apps on Play Store & App Store. Each flavor is a distinct app with unique branding, audio content, and monetization configuration.

## Features

- 📱 **Multi-Flavor Architecture**: Build multiple distinct apps from a single codebase
- 🎵 **Audio Player**: Full-featured audio playback with seek, pause, and duration tracking
- 🎨 **Per-Flavor Customization**: Unique app names, icons, colors per flavor
- 💰 **AdMob Integration**: Per-flavor AdMob configuration for monetization
- 🤖 **Automated Flavor Scaffolding**: Add new flavors with a single command
- 🔒 **Build-Time Asset Correctness**: Impossible to ship wrong audio file
- 🔐 **Environment-Based Secrets**: No hardcoded credentials; CI/CD-ready

## Project Structure

```
islamic_content_audio/
├── lib/
│   ├── main.dart                      # Entry point (FLAVOR routing)
│   ├── config/
│   │   ├── flavor_manager.dart        # Flavor registry
│   │   ├── app_config.dart            # Configuration model
│   │   ├── content_type.dart          # Content type enum
│   │   ├── surah_yaseen_config.dart   # Flavor 1
│   │   ├── surah_muzammil_config.dart # Flavor 2
│   │   └── ...                        # Additional flavors
│   ├── screens/
│   │   └── player_screen.dart         # Main audio player UI
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
│   ├── islamic_content/
│   │   └── audio/                     # 
│   │   └── audio/                     # Runtime audio flavor files (MP3)
│   └── audio                     # 
│   ├── icons                         # 
Splash screen
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
cd islamic_content_audio
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

### 4. Prepare Audio Files

Create audio files in `assets/islamic_content/` directory:
```
assets/
  islamic_content/
      islamic_content.mp3
      ...
```

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

# Surah Muzammil
flutter run --flavor surah_muzammil --dart-define=FLAVOR=surah_muzammil
```

### Run on Specific Device

```bash
flutter devices  # List available devices

flutter run --flavor surah_yaseen --dart-define=FLAVOR=surah_yaseen -d <device-id>
```

### Run in Release Mode

```bash
flutter run --flavor surah_yaseen --dart-define=FLAVOR=surah_yaseen --release
```

## Building for Release

### Build APK (Release)

```bash
flutter build apk --flavor surah_yaseen --dart-define=FLAVOR=surah_yaseen --release
```

**Output**: `build/app/outputs/flutter-apk/app-surah_yaseen-release.apk`

### Build App Bundle for Google Play

```bash
flutter build appbundle --flavor surah_yaseen --dart-define=FLAVOR=surah_yaseen --release
```

**Output**: `build/app/outputs/bundle/surah_yaseenRelease/app-surah_yaseen-release.aab`

### Build for All Flavors

```bash
# APKs
flutter build apk --flavor surah_yaseen --dart-define=FLAVOR=surah_yaseen --release
flutter build apk --flavor surah_muzammil --dart-define=FLAVOR=surah_muzammil --release

# App Bundles
flutter build appbundle --flavor surah_yaseen --dart-define=FLAVOR=surah_yaseen --release
flutter build appbundle --flavor surah_muzammil --dart-define=FLAVOR=surah_muzammil --release
```

## Configuration

### AppConfig Model

Each flavor requires configuration in `lib/config/<flavor>_config.dart`:

```dart
import 'package:islamic_content_audio/config/app_config.dart';
import 'package:islamic_content_audio/config/content_type.dart';
import 'package:islamic_content_audio/secrets/secrets.dart';

const kAppConfig = AppConfig(
  nameArabic: 'سورۃ یٰسٓ',
  nameEnglish: 'Surah Yaseen',
  admobBannerUnitId: Secrets.surahYaseenBannerUnitId,
  contentType: ContentType.surah,
);
```

### Adding New Flavor

Use the automated flavor scaffolder:

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

**Example:**

```bash
dart run scripts/add_flavor.dart \
  --name surah_mulk \
  --arabic "سورۃ الْمُلْک" \
  --english "Surah Mulk" \
  --type surah \
  --app-id com.ummeshuja.surahmulk.audio \
  --banner-id ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx \
  --admob-app-id ca-app-xxxxxxxxxxxxxxxx~xxxxxxxxxx
```

> **Note**: Banner and AdMob IDs are optional. Edit `lib/secrets/secrets.dart` and `android/app/admob.properties` manually if omitted.

## Audio Player Features

### PlayerScreen Widget

The main screen (`lib/screens/player_screen.dart`) provides:

- **Play/Pause Button**: Large circular button with icon feedback
- **Progress Slider**: Seek to any position in the audio
- **Duration Display**: Shows current position and total duration in MM:SS format
- **Header**: Displays Arabic and English names with gradient background
- **AdMob Banner**: Monetization support at the bottom
- **State Management**: Full playback state tracking

### Supported Audio Formats

- MP3 (recommended)
- WAV
- OGG
- AAC
- FLAC

## Dependencies

### Core
- `flutter`: SDK
- `audioplayers: ^6.0.0` - Audio playback engine
- `google_mobile_ads: ^7.0.0` - Monetization (AdMob)
- `flutter_native_splash: ^2.4.0` - Splash screen

### Development
- `flutter_lints: ^6.0.0` - Code quality
- `flutter_launcher_icons: ^0.14.4` - App icon generation

## AdMob Setup

### Configure Secrets

Edit `lib/secrets/secrets.dart`:

```dart
class Secrets {
  static const String surahYaseenBannerUnitId = 'ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyy';
  static const String surahYaseenAdmobAppId = 'ca-app-xxxxxxxxxxxxxxxx~zzzzzzzzzz';
  
  // Add more flavors...
}
```

### Configure Android

Edit `android/app/admob.properties`:

```properties
surah_yaseen_banner_unit_id=ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyy
surah_yaseen_admob_app_id=ca-app-xxxxxxxxxxxxxxxx~zzzzzzzzzz

# Add more flavors...
```

> **Note**: Never commit real AdMob IDs. Use placeholders and override locally.

## Gradle Flavor Configuration

Flavors are defined in `android/app/build.gradle.kts`:

```gradle
flavorDimensions += "version"

productFlavors {
    surah_yaseen {
        dimension "version"
        applicationId "com.ummeshuja.surahyaseen.audio"
        resValue("string", "app_name", "Surah Yaseen")
        // AdMob config loaded from admob.properties
    }
    
    surah_muzammil {
        dimension "version"
        applicationId "com.ummeshuja.surah muzammil.audio"
        resValue("string", "app_name", "Surah Muzammil")
    }
}
```

## Splash Screen

### Generate Splash

```bash
flutter pub run flutter_native_splash:create
```

Configuration is in `pubspec.yaml`:

```yaml
flutter_native_splash:
  color: "#0B3D02"
  image: assets/splash/splash.png
  android: true
  ios: true
  android_gravity: center
  ios_content_mode: center
```

## Testing

### Run Tests

```bash
flutter test
```

### Run with Coverage

```bash
flutter test --coverage
```

## Troubleshooting

### Audio File Not Found

**Problem**: Runtime error "assets/islamic_content/surah_yaseen.mp3 not found"

**Solution**:
1. Check file exists: `ls -la assets/islamic_content/`
2. Verify `pubspec.yaml` includes the folder: `- assets/islamic_content/`
3. Run `flutter pub get` after modifying `pubspec.yaml`
4. Run `flutter clean` then `flutter run`

### Flavor Not Found

**Problem**: Error "Unknown flavor surah_xyz"

**Solution**:
1. Verify config file exists: `lib/config/surah_xyz_config.dart`
2. Add to `FlavorManager._flavors` map in `lib/config/flavor_manager.dart`
3. Verify `android/app/build.gradle.kts` has the productFlavor

### AdMob Banner Not Showing

**Problem**: Banner ad placeholder appears but ad doesn't load

**Solution**:
1. Check AdMob IDs in `lib/secrets/secrets.dart` are valid
2. Use test IDs during development: `ca-app-pub-3940256099942544/6300978111` (banner test ID)
3. Ensure app is release-signed for production builds
4. Check AdMob network status in AdMob console

## Publishing to Play Store

1. **Update Version**: Edit `pubspec.yaml` `version: x.y.z+n`

2. **Build Release Bundle**:
   ```bash
   flutter build appbundle --flavor surah_yaseen --dart-define=FLAVOR=surah_yaseen --release
   ```

3. **Sign APK** (if building APK):
   ```bash
   jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
     -keystore keystore.jks app-release-unsigned.apk alias_name
   ```

4. **Upload to Play Store Console**
   - Go to Release Management → App Releases
   - Upload the `.aab` file
   - Complete store listing and review

## Performance Tips

- **Audio Format**: Use MP3 for smaller file sizes
- **Bitrate**: 128 kbps is sufficient for Quranic audio
- **Duration**: Limit single audio file to < 30 minutes
- **Build Size**: APK size typically 30-50 MB per flavor

## License

This project is proprietary. All Islamic content rights reserved.

## Support

For issues or questions, contact the development team or file an issue in the repository.

---

**Last Updated**: May 2026  
**Current Version**: 1.0.0  
**Flutter SDK**: 3.10.7+
