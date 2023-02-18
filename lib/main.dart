import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'billing_dashboard/billing_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await GetStorage.init();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAErOr6cFrXbm_9SF_MamyXDHhiKOnCNXc",
        authDomain: "shriumeshsonsapp.firebaseapp.com",
        projectId: "shriumeshsonsapp",
        storageBucket: "shriumeshsonsapp.appspot.com",
        messagingSenderId: "207694629480",
        appId: "1:207694629480:web:18814847f52006250bc9dd",
        measurementId: "G-5E9TKFGBTX",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  log('User granted permission: ${settings.authorizationStatus}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BillingDashboard(),
    );
  }
}
