
import 'package:firebase1/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'notification_handeler.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMassageingBackgroundHandeler);
  NotificationHandler.initialize();
  runApp(MyApp());
}


Future<void> firebaseMassageingBackgroundHandeler(RemoteMessage massage)async{

  await Firebase.initializeApp();
  print(massage.notification?.title.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
            home: LoginPage(),
    );
  }
}