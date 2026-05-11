import java.util.Properties
import java.io.FileInputStream


plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.ummeshuja.islamic_content_pdf"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // Load AdMob properties
    val admobProps = Properties()
    val admobPropsFile = file("admob.properties")
    if (admobPropsFile.exists()) {
        admobProps.load(admobPropsFile.inputStream())
    } else {
        println("WARNING: android/app/admob.properties not found.")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // default fallback uses test ID; actual IDs are injected per flavor from admob.properties
        manifestPlaceholders["com.google.android.gms.ads.APPLICATION_ID"] =
            admobProps.getProperty("default.app.id", "")
    }

    flavorDimensions += "content"

    productFlavors {
        create("surah_yaseen") {
            dimension = "content"
            applicationId = "com.ummeshuja.surahyaseen.pdf"
            manifestPlaceholders["appLabel"] = "Surah Yaseen"
            manifestPlaceholders["com.google.android.gms.ads.APPLICATION_ID"] =
                admobProps.getProperty("surah_yaseen.app.id", "")
        }
        create("surah_muzammil") {
            dimension = "content"
            applicationId = "com.ummeshuja.surahmuzammil.pdf"
            manifestPlaceholders["appLabel"] = "Surah Muzammil"
            manifestPlaceholders["com.google.android.gms.ads.APPLICATION_ID"] =
                admobProps.getProperty("surah_muzammil.app.id", "")
        }
    }

    applicationVariants.all {
        val flavor = flavorName
        val sourcePdf = file("${projectDir}/../assets/$flavor/$flavor.pdf")
        val destinationDir = file("${projectDir}/../assets/islamic_content")

        tasks.register("copy${name.capitalize()}Pdf", Copy::class) {
            from(sourcePdf)
            into(destinationDir)
            rename { "islamic_content.pdf" }
        }.let { copyTask ->
            mergeAssetsProvider.configure { dependsOn(copyTask) }
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
