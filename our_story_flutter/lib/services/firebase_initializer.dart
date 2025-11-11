import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseInitializer {
  static FirebaseOptions get webOptions => const FirebaseOptions(
        apiKey: 'AIzaSyD24uQNUWsuvn3r6PZAkvDqUPOheQKhY7Q',
        authDomain: 'ourwebsite-44a4d.firebaseapp.com',
        projectId: 'ourwebsite-44a4d',
        storageBucket: 'ourwebsite-44a4d.firebasestorage.app',
        messagingSenderId: '351109835631',
        appId: '1:351109835631:web:41784c5a83f3d57f97969a',
      );

  static Future<void> initialize() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }

    if (kIsWeb) {
      await Firebase.initializeApp(options: webOptions);
    } else {
      await Firebase.initializeApp();
    }
  }
}

