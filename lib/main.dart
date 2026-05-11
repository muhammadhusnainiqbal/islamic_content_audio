import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:islamic_content_pdf/config/flavor_manager.dart';
import 'package:islamic_content_pdf/config/app_config.dart';
import 'package:islamic_content_pdf/theme/app_theme.dart';
import 'package:islamic_content_pdf/screens/pdf_viewer_screen.dart';

const String _defaultFlavor = String.fromEnvironment('FLAVOR');

Future<void> appMain([String flavor = _defaultFlavor]) async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  final selectedConfig = FlavorManager.getConfig(flavor);

  runApp(MyApp(appConfig: selectedConfig));
}

void main() => appMain();

class MyApp extends StatelessWidget {
  final AppConfig appConfig;

  const MyApp({required this.appConfig, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appConfig.nameEnglish,
      theme: AppTheme.lightTheme,
      home: PdfViewerScreen(appConfig: appConfig),
    );
  }
}
