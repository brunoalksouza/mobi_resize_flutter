import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:mobi_resize_flutter/data/providers/firestore_database_impl.dart';
import 'package:mobi_resize_flutter/data/providers/interfaces/firestore_database.dart';
import 'package:mobi_resize_flutter/pages/login_screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the 'plataforma' Firebase app if not already initialized
  if (Firebase.apps.any((app) => app.name == 'plataforma')) {
    print('Firebase app "plataforma" already initialized');
  } else {
    await Firebase.initializeApp(
      name: "plataforma",
      options: const FirebaseOptions(
        databaseURL: '',
        apiKey: "AIzaSyB53OX3y_lidox9wpVCeCDgSisyrw9tHds",
        authDomain: "plataforma-plus-e5050.firebaseapp.com",
        projectId: "plataforma-plus-e5050",
        storageBucket: "plataforma-plus-e5050.appspot.com",
        messagingSenderId: "276702340459",
        appId: "1:276702340459:web:0cb72490a7d020e69b982e",
        measurementId: "G-98Q8QSS521",
      ),
    );
  }

  // Initialize the 'console' Firebase app if not already initialized
  if (Firebase.apps.any((app) => app.name == 'console')) {
    print('Firebase app "console" already initialized');
  } else {
    await Firebase.initializeApp(
      name: "console",
      options: const FirebaseOptions(
        apiKey: "AIzaSyCHZXOy-kZ2zOyoCe6eKP_VDkH4-1QW63E",
        authDomain: "mobiplus-console.firebaseapp.com",
        databaseURL: "https://mobiplus-console.firebaseio.com",
        projectId: "mobiplus-console",
        storageBucket: "mobiplus-console.appspot.com",
        messagingSenderId: "338468369875",
        appId: "1:338468369875:web:b0ec7d29125fa10a136b26",
        measurementId: "G-M30B0BVNFD",
      ),
    );
  }

  // Dependency injection for Firebase apps
  Get.put<FirestoreDatabase>(
    FirestoreDatabaseImpl(appName: 'console') as FirestoreDatabase,
    tag: 'consoleFirebase',
    permanent: true,
  );

  Get.put<FirestoreDatabase>(
    FirestoreDatabaseImpl(appName: 'plataforma') as FirestoreDatabase,
    tag: 'plataformaFirebase',
    permanent: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: LoginScreen(),
    );
  }
}
