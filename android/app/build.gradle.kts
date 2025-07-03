import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Bagian untuk membaca file key.properties dalam sintaks Kotlin
val keystorePropertiesFile = rootProject.file("../key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.alianta.gostay"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // Menambahkan konfigurasi penandatanganan (signing) untuk rilis dalam sintaks Kotlin
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                val keyAliasValue = keystoreProperties.getProperty("keyAlias")
                val keyPasswordValue = keystoreProperties.getProperty("keyPassword")
                val storeFileValue = keystoreProperties.getProperty("storeFile")
                val storePasswordValue = keystoreProperties.getProperty("storePassword")
                
                if (keyAliasValue != null && keyPasswordValue != null && 
                    storeFileValue != null && storePasswordValue != null) {
                    keyAlias = keyAliasValue
                    keyPassword = keyPasswordValue
                    storeFile = file(storeFileValue)
                    storePassword = storePasswordValue
                }
            }
        }
    }

    defaultConfig {
        applicationId = "com.alianta.gostay"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            // Menggunakan konfigurasi rilis jika tersedia
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            }

            // Mengaktifkan optimasi untuk ukuran aplikasi yang lebih kecil
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}