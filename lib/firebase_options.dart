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
    apiKey: 'AIzaSyBrhh6kOHMsyEq7w6u42XIqo6o5Yw90jno',
    appId: '1:576771086062:web:55cb7fee31b88cee3dc5ff',
    messagingSenderId: '576771086062',
    projectId: 'map-my-walk-2e3e4',
    authDomain: 'map-my-walk-2e3e4.firebaseapp.com',
    storageBucket: 'map-my-walk-2e3e4.appspot.com',
    measurementId: 'G-F7L5D0E7SK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB47-cJpx5w675xvNhsqnKwsaqYRpvRhsQ',
    appId: '1:576771086062:android:455e634f839b2d6a3dc5ff',
    messagingSenderId: '576771086062',
    projectId: 'map-my-walk-2e3e4',
    storageBucket: 'map-my-walk-2e3e4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDPISmGOSAq_Ihjr9hnRxpIQCIMJMbSj38',
    appId: '1:576771086062:ios:56182177cc32c4da3dc5ff',
    messagingSenderId: '576771086062',
    projectId: 'map-my-walk-2e3e4',
    storageBucket: 'map-my-walk-2e3e4.appspot.com',
    iosClientId: '576771086062-nv1mbjaffbpm04pu6b7q1nstr1upqbm1.apps.googleusercontent.com',
    iosBundleId: 'com.usamamuzaffar.mapMyWalk',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDPISmGOSAq_Ihjr9hnRxpIQCIMJMbSj38',
    appId: '1:576771086062:ios:ee3d127a25dbee593dc5ff',
    messagingSenderId: '576771086062',
    projectId: 'map-my-walk-2e3e4',
    storageBucket: 'map-my-walk-2e3e4.appspot.com',
    iosClientId: '576771086062-cdp0t6sr3dk16eb25okrmqdbhnlno91m.apps.googleusercontent.com',
    iosBundleId: 'com.usamamuzaffar.mapMyWalk.RunnerTests',
  );
}