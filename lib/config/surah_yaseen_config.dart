import 'package:islamic_content_pdf/config/app_config.dart';
import 'package:islamic_content_pdf/config/content_type.dart';
import 'package:islamic_content_pdf/secrets/secrets.dart';

/// Surah Yaseen Configuration
const kAppConfig = AppConfig(
  nameArabic: 'سورۃ یٰسٓ',
  nameEnglish: 'Surah Yaseen',
  admobBannerUnitId: Secrets.surahYaseenBannerUnitId,
  contentType: ContentType.surah,
);
