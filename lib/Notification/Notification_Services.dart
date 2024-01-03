
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationServices {

  FirebaseMessaging massing = FirebaseMessaging.instance;

 final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void requestNotificationPermissin() async {
    NotificationSettings settings = await massing.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("user granted permission");
    }else if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("user granted provisional permission");

    }else{

      print("user denied permission");
    }


  }

void initLocalNotificaton(BuildContext context,RemoteMessage message) async{
  var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(
    android:  androidInitializationSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (payload){
      // handle interaction when app is active for android
    }
  );
}
 void firebaseInit(BuildContext context){
   FirebaseMessaging.onMessage.listen((message) {

     RemoteNotification? notification = message.notification ;
     AndroidNotification? android = message.notification!.android ;

     if (kDebugMode) {
       print("notifications title:${notification!.title}");
       print("notifications body:${notification.body}");
       print('count:${android!.count}');
       print('data:${message.data.toString()}');
     }
       showNotification(message);

   });
 }

  Future<void> showNotification(RemoteMessage message)async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString() ,
        importance: Importance.max  ,
        showBadge: true ,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString() ,
        channelDescription: 'your channel description',
        importance: Importance.high,
        priority: Priority.high ,
        playSound: true,
        ticker: 'ticker' ,
        sound: channel.sound
      //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
      //  icon: largeIconPath
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
        presentAlert: true ,
        presentBadge: true ,
        presentSound: true
    ) ;

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero , (){
      flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails ,
      );
    });

  }
  Future<String> getDeviceToken()async{

    String? token = await massing.getToken();
    return token!;

  }

  void isTokenRefresh()async{
    massing.onTokenRefresh.listen((event) {
      event.toString();
      print("refresh");
    });

  }
}

//
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class FirebaseMessagingService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//   Future<void> initialize() async {
//     await _firebaseMessaging.requestPermission();
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // Handle incoming messages
//       print("Received message: ${message.notification?.title}");
//     });
//   }
//
//   Future<String> getDeviceToken() async {
//     return await _firebaseMessaging.getToken() ?? "";
//   }
// }
