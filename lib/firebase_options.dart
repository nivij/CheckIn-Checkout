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
    apiKey: 'AIzaSyBqg6tzijmT13OU76OIpfNyeNpUO9Rjw9Y',
    appId: '1:731036034876:web:e86d50304a0a4bb0292039',
    messagingSenderId: '731036034876',
    projectId: 'codenoralabs-7f980',
    authDomain: 'codenoralabs-7f980.firebaseapp.com',
    storageBucket: 'codenoralabs-7f980.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC7m3wUWpdnyap9aJdUVs56ZVyiNi5cCXw',
    appId: '1:731036034876:android:f44fbbdc76f5d41d292039',
    messagingSenderId: '731036034876',
    projectId: 'codenoralabs-7f980',
    storageBucket: 'codenoralabs-7f980.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDcSnaXX26LCCAnF7and_WhXfgYBi4JsfY',
    appId: '1:731036034876:ios:14937a21fb7a108d292039',
    messagingSenderId: '731036034876',
    projectId: 'codenoralabs-7f980',
    storageBucket: 'codenoralabs-7f980.appspot.com',
    androidClientId: '731036034876-t4ledt7o2sdn2nqruabbqqc9nd8e65q7.apps.googleusercontent.com',
    iosClientId: '731036034876-1tenkvbksir4iq72qk3skgbsuh0h8jiv.apps.googleusercontent.com',
    iosBundleId: 'com.example.codenoralabs',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDcSnaXX26LCCAnF7and_WhXfgYBi4JsfY',
    appId: '1:731036034876:ios:14937a21fb7a108d292039',
    messagingSenderId: '731036034876',
    projectId: 'codenoralabs-7f980',
    storageBucket: 'codenoralabs-7f980.appspot.com',
    androidClientId: '731036034876-t4ledt7o2sdn2nqruabbqqc9nd8e65q7.apps.googleusercontent.com',
    iosClientId: '731036034876-1tenkvbksir4iq72qk3skgbsuh0h8jiv.apps.googleusercontent.com',
    iosBundleId: 'com.example.codenoralabs',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBqg6tzijmT13OU76OIpfNyeNpUO9Rjw9Y',
    appId: '1:731036034876:web:61ecc77d50408d6b292039',
    messagingSenderId: '731036034876',
    projectId: 'codenoralabs-7f980',
    authDomain: 'codenoralabs-7f980.firebaseapp.com',
    storageBucket: 'codenoralabs-7f980.appspot.com',
  );

}