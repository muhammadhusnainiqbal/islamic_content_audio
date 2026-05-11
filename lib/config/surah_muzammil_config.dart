import 'package:islamic_content_pdf/config/app_config.dart';
import 'package:islamic_content_pdf/config/content_type.dart';
import 'package:islamic_content_pdf/secrets/secrets.dart';

/// Surah Muzammil Configuration
const kAppConfig = AppConfig(
  nameArabic: 'سورة المزمل',
  nameEnglish: 'Surah Muzammil',
  admobBannerUnitId: Secrets.surahMuzammilBannerUnitId,
  contentType: ContentType.surah,
);
