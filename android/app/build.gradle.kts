import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keyProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) {
        load(file.inputStream())
    }
}

android {
    namespace = "com.amoeba.gvmarket"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.amoeba.gvmarket"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (keyProperties.isNotEmpty()) {
            create("prod") {
                storeFile = file(keyProperties["storeFile"] as String)
                storePassword = keyProperties["storePassword"] as String
                keyAlias = keyProperties["keyAlias"] as String
                keyPassword = keyProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            if (signingConfigs.findByName("release") != null) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }

    flavorDimensions += "app"

    productFlavors {
        create("dev") {
            dimension = "app"
            applicationId = "com.amoeba.gvmarket.dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "GVMarket Dev")
            manifestPlaceholders["facebookAppId"] = "824602119947976"
        }

        create("prod") {
            dimension = "app"
            applicationId = "com.amoeba.avenue.gvmarket"
            resValue("string", "app_name", "GV Market")
            signingConfig = signingConfigs.getByName("prod")
            manifestPlaceholders["facebookAppId"] = "1325878712414469"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.1.0"))
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

