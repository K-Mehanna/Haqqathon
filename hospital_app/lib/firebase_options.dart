// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAC4MwR7ZLdhUDuow6nkXcTGm7eYLHnPOI',
    appId: '1:2153146325:web:1fe9fc93671269a6083f5c',
    messagingSenderId: '2153146325',
    projectId: 'haqqathon-b3b3d',
    authDomain: 'haqqathon-b3b3d.firebaseapp.com',
    storageBucket: 'haqqathon-b3b3d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdwRuMiewEQsWSoT69LGzI2ex1JL_Pmn4',
    appId: '1:2153146325:android:fd8dfa1fda86c91d083f5c',
    messagingSenderId: '2153146325',
    projectId: 'haqqathon-b3b3d',
    storageBucket: 'haqqathon-b3b3d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD37LVk_NtwDwEcRxVu13c_dBJpvo9aUOA',
    appId: '1:2153146325:ios:a01877a372e6907f083f5c',
    messagingSenderId: '2153146325',
    projectId: 'haqqathon-b3b3d',
    storageBucket: 'haqqathon-b3b3d.appspot.com',
    iosBundleId: 'com.example.hospitalApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD37LVk_NtwDwEcRxVu13c_dBJpvo9aUOA',
    appId: '1:2153146325:ios:a01877a372e6907f083f5c',
    messagingSenderId: '2153146325',
    projectId: 'haqqathon-b3b3d',
    storageBucket: 'haqqathon-b3b3d.appspot.com',
    iosBundleId: 'com.example.hospitalApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAC4MwR7ZLdhUDuow6nkXcTGm7eYLHnPOI',
    appId: '1:2153146325:web:74e870cd6e0ce16a083f5c',
    messagingSenderId: '2153146325',
    projectId: 'haqqathon-b3b3d',
    authDomain: 'haqqathon-b3b3d.firebaseapp.com',
    storageBucket: 'haqqathon-b3b3d.appspot.com',
  );

}