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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCxY9jc4KIp-UhXtTkw8V4eUZbYkPZuMgs',
    appId: '1:648526360807:web:a8f072313cbef1fbc17242',
    messagingSenderId: '648526360807',
    projectId: 'ca-appoinment',
    authDomain: 'ca-appoinment.firebaseapp.com',
    storageBucket: 'ca-appoinment.appspot.com',
    measurementId: 'G-XFLNCWJXC7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBpBfdw_BeTQr6X7NPBBddT-or_E_uHdSk',
    appId: '1:648526360807:android:7664b906272d10acc17242',
    messagingSenderId: '648526360807',
    projectId: 'ca-appoinment',
    storageBucket: 'ca-appoinment.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYeGLtoRaxPdJG4S259YTGkkhG2oVIyt0',
    appId: '1:648526360807:ios:5c81bf33d7327594c17242',
    messagingSenderId: '648526360807',
    projectId: 'ca-appoinment',
    storageBucket: 'ca-appoinment.appspot.com',
    androidClientId: '648526360807-a80g8ncidji06ung6gr822ba7r3glqkv.apps.googleusercontent.com',
    iosBundleId: 'com.example.caAppoinment',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCYeGLtoRaxPdJG4S259YTGkkhG2oVIyt0',
    appId: '1:648526360807:ios:3c07f1df6341ec76c17242',
    messagingSenderId: '648526360807',
    projectId: 'ca-appoinment',
    storageBucket: 'ca-appoinment.appspot.com',
    androidClientId: '648526360807-a80g8ncidji06ung6gr822ba7r3glqkv.apps.googleusercontent.com',
    iosBundleId: 'com.example.caAppoinment.RunnerTests',
  );
}
