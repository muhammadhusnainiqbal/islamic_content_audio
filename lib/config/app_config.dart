import 'content_type.dart';

/// Configuration model for a PDF app instance
class AppConfig {
  /// Arabic name of the content (e.g., 'سورۃ یٰسٓ')
  final String nameArabic;

  /// English name of the content (e.g., 'Yaseen')
  final String nameEnglish;

  /// AdMob Banner Ad Unit ID
  final String admobBannerUnitId;

  /// Type of Islamic content
  final ContentType contentType;

  const AppConfig({
    required this.nameArabic,
    required this.nameEnglish,
    required this.admobBannerUnitId,
    required this.contentType,
  });
}
