#!/usr/bin/env dart
// ─────────────────────────────────────────────────────────────────────────────
// add_flavor.dart  —  Islamic Content PDF App: New Flavor Scaffolder
// ─────────────────────────────────────────────────────────────────────────────
//
// Usage:
//   dart run scripts/add_flavor.dart \
//     --name       surah_mulk              (snake_case, required)
//     --arabic     "سورۃ الملک"            (Arabic name, required)
//     --english    "Surah Mulk"             (English name, required)
//     --type       surah                   (surah|dua|ayat|darood|other, default: surah)
//     --app-id     com.ummeshuja.surah_mulk (Android app ID, optional)
//     --banner-id  ca-app-pub-xxx/yyy      (AdMob banner unit ID, optional)
//     --admob-app-id ca-app-pub-xxx~zzz   (AdMob app ID, optional)
//
// ── What you must do FIRST (Step 1 — script cannot do this for you) ────────
//   ❌ Place your PDF:  assets/<name>/<name>.pdf
//   ❌ Place your icon: assets/<name>/<name>_icon.png  (1024×1024 PNG)
//
// ── What this script does automatically ──────────────────────────────────
//   ✅ Step 2:  Copies PDF  → assets/islamic_content/islamic_content.pdf
//   ✅ Step 3:  Copies icon → assets/icons/app_icon.png
//   ✅ Step 4:  Creates lib/config/<name>_config.dart
//   ✅ Step 5:  Registers flavor in lib/config/flavor_manager.dart
//   ✅ Step 6:  Writes AdMob banner unit ID to lib/secrets/secrets.dart
//              (uses --banner-id if provided, otherwise uses --app-id as placeholder)
//   ✅ Step 7:  Adds productFlavor to android/app/build.gradle.kts
//   ✅ Step 8:  Writes AdMob app ID to android/app/admob.properties
//              (uses --admob-app-id if provided, otherwise uses --app-id as placeholder)
//   ✅ Step 9:  Runs flutter pub run flutter_launcher_icons (if icon present)
// ─────────────────────────────────────────────────────────────────────────────

// dart run scripts/add_flavor.dart --name surah_yaseen --arabic  "سورۃ یٰس" --english "Surah Yaseen" --type surah --app-id com.ummeshuja.surah_yaseen --banner-id ca-app-pub-3429461176010191/8233759602 --admob-app-id ca-app-pub-3429461176010191~6638041674

// dart run scripts/add_flavor.dart --name surah_yaseen --arabic  "سورۃ یٰس" --english "Surah Yaseen" --type surah --app-id com.ummeshuja.surah_yaseen --banner-id ca-app-pub-3940256099942544/6300978111 --admob-app-id ca-app-pub-3940256099942544~3347511713
// dart run scripts/add_flavor.dart --name surah_rehman --arabic  "سورۃ الرحمن" --english "Surah Rahman" --type surah --app-id com.ummeshuja.surah_rehman --banner-id ca-app-pub-3940256099942544/6300978111 --admob-app-id ca-app-pub-3940256099942544~3347511713
// dart run scripts/add_flavor.dart --name surah_mulk --arabic  "سورۃ الملک" --english "Surah Mulk" --type surah --app-id com.ummeshuja.surah_mulk --banner-id ca-app-pub-3940256099942544/6300978111 --admob-app-id ca-app-pub-3940256099942544~3347511713

import 'dart:io';

void main(List<String> args) {
  // ── Parse arguments ─────────────────────────────────────────────────────
  final parsed = _parseArgs(args);
  if (parsed == null) {
    _printUsage();
    exit(1);
  }

  final name = parsed['name']!;
  final arabic = parsed['arabic']!;
  final english = parsed['english']!;
  final type = parsed['type'] ?? 'surah';
  final appId = parsed['app-id'] ?? 'com.ummeshuja.${name}_pdf';
  // Optional real AdMob IDs. If not provided, appId is used as placeholder.
  final bannerId =
      parsed['banner-id']; // AdMob banner unit ID (ca-app-pub-xxx/yyy)
  final admobAppId =
      parsed['admob-app-id']; // AdMob app ID       (ca-app-pub-xxx~zzz)

  // ── Validate name ────────────────────────────────────────────────────────
  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(name)) {
    _err(
      'Flavor name must be lowercase letters, digits, and underscores only.',
    );
    exit(1);
  }

  _log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  _log(' Islamic PDF App — Adding flavor: $name');
  _log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // ── Step 1: Verify source assets exist BEFORE touching any code ──────────
  _step('1', 'Verifying source assets');
  final pdfSrc = File('assets/$name/$name.pdf');
  final iconSrc = File('assets/$name/${name}_icon.png');
  final hasIcon = iconSrc.existsSync();

  if (!pdfSrc.existsSync()) {
    _err('Missing PDF: ${pdfSrc.path}');
    _err('Create the file and re-run this script.');
    exit(2);
  }
  _log('  ✔ PDF found:  ${pdfSrc.path}');

  if (!hasIcon) {
    _warn('Icon not found: ${iconSrc.path}');
    _warn('Icon steps (3, 9) will be skipped. Add it later and run:');
    _warn('  dart run scripts/add_flavor.dart --name $name ... (re-run)');
  } else {
    _log('  ✔ Icon found: ${iconSrc.path}');
  }

  // ── Step 2: Copy PDF to shared runtime location ──────────────────────────
  _step('2', 'Copying PDF → assets/islamic_content/islamic_content.pdf');
  _copyAsset(
    src: pdfSrc.path,
    dstDir: 'assets/islamic_content',
    dstName: 'islamic_content.pdf',
  );

  // ── Step 3: Copy icon to shared runtime location ─────────────────────────
  if (hasIcon) {
    _step('3', 'Copying icon → assets/icons/app_icon.png');
    _copyAsset(
      src: iconSrc.path,
      dstDir: 'assets/icons',
      dstName: 'app_icon.png',
    );
  } else {
    _step('3', 'Skipped (no icon file found)');
  }

  // ── Step 4: Create flavor config dart file ───────────────────────────────
  _step('4', 'Creating lib/config/${name}_config.dart');
  _createConfigFile(name, arabic, english, type);

  // ── Step 5: Register flavor in FlavorManager ─────────────────────────────
  _step('5', 'Registering flavor in lib/config/flavor_manager.dart');
  _registerInFlavorManager(name);

  // ── Step 6: Add AdMob banner unit ID ─────────────────────────────────────
  _step('6', 'Writing AdMob banner unit ID to lib/secrets/secrets.dart');
  _addSecret(name, bannerId ?? appId, isPlaceholder: bannerId == null);

  // ── Step 7: Add Gradle productFlavor ─────────────────────────────────────
  _step('7', 'Adding productFlavor to android/app/build.gradle.kts');
  _addGradleFlavor(name, english, appId);

  // ── Step 8: Add AdMob app ID ──────────────────────────────────────────────
  _step('8', 'Writing AdMob app ID to android/app/admob.properties');
  _addAdmobProperty(
    name,
    admobAppId ?? appId,
    isPlaceholder: admobAppId == null,
  );

  // ── Step 9: Generate launcher icons ──────────────────────────────────────
  if (hasIcon) {
    _step('9', 'Generating launcher icons');
    _runLauncherIcons();
  } else {
    _step('9', 'Skipped (no icon file)');
  }

  // ── Done ─────────────────────────────────────────────────────────────────
  _log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  _log(' ✅  Flavor "$name" scaffolded successfully!');
  _log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  final needsIds = bannerId == null || admobAppId == null;
  if (needsIds) {
    _log('⚡ Next steps:\n');
    _log('  1. Replace placeholder AdMob IDs with your real ones:');
    if (bannerId == null) {
      _log('     lib/secrets/secrets.dart → ${_toCamelCase(name)}BannerUnitId');
      _log('       Current: "$appId"');
      _log('       Replace: ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY\n');
    }
    if (admobAppId == null) {
      _log('     android/app/admob.properties → $name.app.id');
      _log('       Current: "$appId"');
      _log('       Replace: ca-app-pub-XXXXXXXXXXXXXXXX~ZZZZZZZZZZ\n');
    }
  } else {
    _log('⚡ All AdMob IDs written — no manual edits needed!\n');
  }
  _log(
    '  Test:  flutter run -t lib/main.dart --flavor $name --dart-define=FLAVOR=$name',
  );
  _log(
    '  Build: flutter build appbundle --flavor $name -t lib/main.dart --dart-define=FLAVOR=$name --release',
  );
}

// ── Step implementations ─────────────────────────────────────────────────────

/// Copies [src] file to [dstDir]/[dstName], creating the directory if needed.
/// Pure Dart — no shell script dependency.
void _copyAsset({
  required String src,
  required String dstDir,
  required String dstName,
}) {
  final srcFile = File(src);
  final dstDirectory = Directory(dstDir);
  if (!dstDirectory.existsSync()) {
    dstDirectory.createSync(recursive: true);
    _log('  Created directory: $dstDir');
  }
  final dstFile = File('$dstDir/$dstName');
  srcFile.copySync(dstFile.path);
  final kb = (srcFile.lengthSync() / 1024).toStringAsFixed(1);
  _log('  Copied: $src → ${dstFile.path} ($kb KB)');
}

void _createConfigFile(
  String name,
  String arabic,
  String english,
  String type,
) {
  final file = File('lib/config/${name}_config.dart');
  final camel = _toCamelCase(name);
  file.writeAsStringSync(
    "import 'package:islamic_content_pdf/config/app_config.dart';\n"
    "import 'package:islamic_content_pdf/config/content_type.dart';\n"
    "import 'package:islamic_content_pdf/secrets/secrets.dart';\n"
    '\n'
    '/// $english Configuration\n'
    'const kAppConfig = AppConfig(\n'
    "  nameArabic: '$arabic',\n"
    "  nameEnglish: '$english',\n"
    '  admobBannerUnitId: Secrets.${camel}BannerUnitId,\n'
    '  contentType: ContentType.$type,\n'
    ');\n',
  );
  _log('  Created: ${file.path}');
}

void _registerInFlavorManager(String name) {
  final file = File('lib/config/flavor_manager.dart');
  var content = file.readAsStringSync();

  // If already registered, remove old import and entry
  if (content.contains("'$name'")) {
    _log('  Flavor "$name" already exists — updating...');

    // Remove old import line
    content = content.replaceAll(
      RegExp(
        r"import 'package:islamic_content_pdf/config/" +
            RegExp.escape(name) +
            r"_config\.dart'\s+as\s+" +
            RegExp.escape(name) +
            r";\s*\n+",
      ),
      '',
    );

    // Map entry will be validated/added below
  }

  // 1. Insert import before the "/// Flavor manager:" doc comment
  final importLine =
      "import 'package:islamic_content_pdf/config/${name}_config.dart'\n"
      "    as $name;\n";
  content = content.replaceFirst(
    '/// Flavor manager:',
    '$importLine\n/// Flavor manager:',
  );

  // 2. Ensure the map entry exists (add if new flavor)
  if (!content.contains("'$name': $name.kAppConfig,")) {
    final mapEntry = "    '$name': $name.kAppConfig,\n";
    final lastEntryPattern = RegExp(
      r'(\.kAppConfig,)\s*\n(\s*\};)',
      multiLine: true,
    );

    if (lastEntryPattern.hasMatch(content)) {
      content = content.replaceFirstMapped(lastEntryPattern, (match) {
        final trailing = match.group(2)!; // "  };"
        return '${match.group(1)}\n$mapEntry$trailing';
      });
    }
  }

  file.writeAsStringSync(content);
  _log('  Updated: ${file.path}');
}

void _addSecret(String name, String idValue, {bool isPlaceholder = false}) {
  final file = File('lib/secrets/secrets.dart');
  var content = file.readAsStringSync();
  final camel = _toCamelCase(name);
  final envKey = '${name.toUpperCase()}_BANNER_AD_UNIT_ID';

  // If already exists, remove old entry to avoid duplicates
  if (content.contains('${camel}BannerUnitId')) {
    _log('  Secret "${camel}BannerUnitId" already exists — updating...');
    // Remove old field by matching the static const line with the camelCase var name
    // This works regardless of what the comment says
    content = content.replaceAll(
      RegExp(
        r'\n?  // [^\n]*\n\s*static const String ' +
            RegExp.escape(camel) +
            r'BannerUnitId = String\.fromEnvironment\(\s*' +
            r"'[^']*',\s*" +
            r"defaultValue: '[^']*',\s*" +
            r'\);\n',
        dotAll: true,
      ),
      '',
    );
  }

  final comment = isPlaceholder
      ? '  // $name Flavor — PLACEHOLDER: replace defaultValue with real banner unit ID (ca-app-pub-xxx/yyy)'
      : '  // $name Flavor';

  final field =
      '\n$comment\n'
      '  static const String ${camel}BannerUnitId = String.fromEnvironment(\n'
      "    '$envKey',\n"
      "    defaultValue: '$idValue',\n"
      '  );\n';

  content = content.replaceFirst('}\n', '$field}\n');
  file.writeAsStringSync(content);

  if (isPlaceholder) {
    _warn(
      '  Placeholder written. Replace "$idValue" with real AdMob banner unit ID.',
    );
  } else {
    _log('  Updated: ${file.path} (✔ real banner unit ID written)');
  }
}

void _addGradleFlavor(String name, String english, String appId) {
  final file = File('android/app/build.gradle.kts');
  var content = file.readAsStringSync();

  // If already exists, remove old flavor block to avoid duplicates
  if (content.contains('"$name"')) {
    _log('  Gradle flavor "$name" already exists — updating...');
    // Remove old flavor block - simple approach
    final pattern = RegExp(
      r'        create\("' + name + r'"\) \{[^}]*\}\n',
      dotAll: true,
    );
    content = content.replaceAll(pattern, '');
  }

  // Anchor: find closing `    }` of the productFlavors block
  // which is immediately followed by two newlines + applicationVariants
  final newBlock =
      '        create("$name") {\n'
      '            dimension = "content"\n'
      '            applicationId = "$appId"\n'
      '            manifestPlaceholders["appLabel"] = "$english"\n'
      '            manifestPlaceholders["com.google.android.gms.ads.APPLICATION_ID"] =\n'
      '                admobProps.getProperty("$name.app.id", "")\n'
      '        }\n'
      '    }';

  content = content.replaceFirst(
    RegExp(r'    \}\n\n    applicationVariants'),
    '$newBlock\n\n    applicationVariants',
  );

  file.writeAsStringSync(content);
  _log('  Updated: ${file.path}');
}

void _addAdmobProperty(
  String name,
  String idValue, {
  bool isPlaceholder = false,
}) {
  final file = File('android/app/admob.properties');
  var content = file.readAsStringSync();

  // If already exists, remove old entry to avoid duplicates
  if (content.contains('$name.app.id')) {
    _log('  Entry "$name.app.id" already exists — updating...');
    // Remove old property (may or may not have a comment)
    // Pattern 1: comment + property line
    // Pattern 2: standalone property line
    content = content.replaceAll(
      RegExp(
        r'(\n+# ' +
            RegExp.escape(name) +
            r'[^\n]*\n)?' +
            RegExp.escape(name) +
            r'\.app\.id=[^\n]*\n?',
      ),
      '\n',
    );
  }

  if (!content.endsWith('\n')) content += '\n';

  final comment = isPlaceholder
      ? '# $name — PLACEHOLDER: replace with real AdMob App ID (ca-app-pub-xxx~zzz) from admob.google.com'
      : '# $name';
  content += '\n$comment\n$name.app.id=$idValue\n';

  file.writeAsStringSync(content);

  if (isPlaceholder) {
    _warn('  Placeholder written. Replace "$idValue" with real AdMob app ID.');
  } else {
    _log('  Updated: ${file.path} (✔ real AdMob app ID written)');
  }
}

void _runLauncherIcons() {
  _log('  Running: flutter pub run flutter_launcher_icons ...');
  final result = Process.runSync('flutter', [
    'pub',
    'run',
    'flutter_launcher_icons',
  ], runInShell: true);
  if (result.exitCode == 0) {
    _log('  ✔ Launcher icons generated.');
  } else {
    _warn('  flutter_launcher_icons exited with code ${result.exitCode}.');
    _warn('  Run manually: flutter pub run flutter_launcher_icons');
    if (result.stderr.toString().isNotEmpty) {
      _warn('  ${result.stderr.toString().trim()}');
    }
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

/// Converts snake_case to lowerCamelCase.
/// surah_yaseen → surahYaseen
String _toCamelCase(String snake) {
  final parts = snake.split('_');
  return parts.first +
      parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
}

Map<String, String>? _parseArgs(List<String> args) {
  if (args.isEmpty) return null;
  final result = <String, String>{};
  for (var i = 0; i < args.length - 1; i++) {
    if (args[i].startsWith('--')) {
      result[args[i].substring(2)] = args[i + 1];
      i++;
    }
  }
  if (!result.containsKey('name') ||
      !result.containsKey('arabic') ||
      !result.containsKey('english')) {
    return null;
  }
  return result;
}

void _printUsage() {
  print('''
Islamic PDF App — Flavor Scaffolder
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Required:
  --name      surah_mulk                    (snake_case identifier)
  --arabic    "سورۃ الملک"                  (Arabic display name)
  --english   "Surah Mulk"                 (English display name)

Optional:
  --type          surah                    (surah|dua|ayat|darood|other, default: surah)
  --app-id        com.ummeshuja.surah_mulk  (Android app ID)
  --banner-id     ca-app-pub-xxx/yyy       (AdMob banner unit ID — uses --app-id as placeholder if omitted)
  --admob-app-id  ca-app-pub-xxx~zzz       (AdMob app ID        — uses --app-id as placeholder if omitted)

Before running, place source files:
  assets/surah_mulk/surah_mulk.pdf            ← PDF file
  assets/surah_mulk/surah_mulk_icon.png       ← 1024×1024 PNG icon

Example 1 — placeholder IDs (edit AdMob IDs manually after):
  dart run scripts/add_flavor.dart \\
    --name surah_mulk \\
    --arabic "سورۃ الملک" \\
    --english "Surah Mulk" \\
    --app-id com.ummeshuja.surah_mulk

Example 2 — real AdMob IDs (fully automated, zero manual edits needed):
  dart run scripts/add_flavor.dart \\
    --name surah_mulk \\
    --arabic "سورۃ الملک" \\
    --english "Surah Mulk" \\
    --app-id com.ummeshuja.surah_mulk \\
    --banner-id ca-app-pub-3940256099942544/6300978111 \\
    --admob-app-id ca-app-pub-3940256099942544~3347511713

islamic_content_pdf % dart run scripts/add_flavor.dart --name surah_mulk --arabic  "سورۃ الملک" --english "Surah Mulk" --type surah --app-id com.ummeshuja.surah_mulk --banner-id ca-app-pub-3940256099942544/6300978111 --admob-app-id ca-app-pub-3940256099942544~3347511713

''');
}

void _step(String n, String msg) => print('\n[Step $n] $msg');
void _log(String msg) => print(msg);
void _warn(String msg) => stderr.writeln('  ⚠  $msg');
void _err(String msg) => stderr.writeln('  ✖  $msg');
