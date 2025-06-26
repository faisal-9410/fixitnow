// File: android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.fixitnow"
    compileSdk = 34
    ndkVersion = "29.0.13599879" // ✅ Your original NDK version restored

    defaultConfig {
        applicationId = "com.example.fixitnow"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

  buildTypes {
    getByName("release") {
        isMinifyEnabled = false
        isShrinkResources = false // ✅ Must be false if minify is false
        signingConfig = signingConfigs.getByName("debug")
    }
}


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.firebase:firebase-auth:22.3.1")
    implementation("com.google.firebase:firebase-firestore:24.11.0")
    implementation("com.google.firebase:firebase-storage:20.3.0")

    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
