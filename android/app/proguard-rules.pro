# --- Flutter / Dart ---
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**

# --- Firebase / Google Play Services (reflection + Parcelable heavy) ---
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Firestore POJO (de)serialization relies on reflection over your model classes.
# If you have @PropertyName / manual fromJson models under lib/src/core/model,
# keep the generated Android classes that mirror them too:
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keepattributes Exceptions

# --- Google Sign-In (Credential Manager based, v7+) ---
-keep class com.google.android.libraries.identity.googleid.** { *; }
-keep class androidx.credentials.** { *; }
-dontwarn androidx.credentials.**
-dontwarn com.google.android.libraries.identity.googleid.**

# --- Google Maps ---
-keep class com.google.android.gms.maps.** { *; }
-keep interface com.google.android.gms.maps.** { *; }

# --- Google Mobile Ads ---
-keep class com.google.android.gms.ads.** { *; }

# --- JNI plugins (dart_lang jni / jni_flutter) ---
-keep class com.github.dart_lang.jni.** { *; }
-keep class com.github.dart_lang.jni_flutter.** { *; }
-dontwarn com.github.dart_lang.**

# --- Geolocator / file_picker / other native plugins ---
-keep class com.baseflow.geolocator.** { *; }
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# --- AndroidX Room / WorkManager (fixes "Failed to create an instance of
# androidx.work.impl.WorkDatabase" crash on startup) ---
-keep class androidx.work.** { *; }
-keep class * extends androidx.room.RoomDatabase { *; }
-keep @androidx.room.Database class * { *; }
-keep class androidx.sqlite.** { *; }
-keepclassmembers class * extends androidx.room.RoomDatabase {
    public static <fields>;
}
-dontwarn androidx.room.paging.**

# --- androidx.startup (InitializationProvider that triggers WorkManager init) ---
-keep class androidx.startup.** { *; }
-keep class * implements androidx.startup.Initializer { *; }

# --- General safety net ---
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
