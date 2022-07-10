// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD6wlBxYZ6t8dILpCVQsnU94A0lIN-LoL0',
    appId: '1:325860836584:android:343619505cf8b9fe16755d',
    messagingSenderId: '325860836584',
    projectId: 'woo-ecommerce-flutter-app',
    storageBucket: 'woo-ecommerce-flutter-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFkOpicKf-ILVmkZgCcVHbJHWzSkiB_Ww',
    appId: '1:325860836584:ios:6cd4ae16e0bf675e16755d',
    messagingSenderId: '325860836584',
    projectId: 'woo-ecommerce-flutter-app',
    storageBucket: 'woo-ecommerce-flutter-app.appspot.com',
    iosClientId: '325860836584-rh8r3or0pfmbee990qvrupjv2ito9r83.apps.googleusercontent.com',
    iosBundleId: 'com.example.wooEcommerceFlutterApp',
  );
}
