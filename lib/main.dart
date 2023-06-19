import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localnotification/home.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // FlutterLocalNotificationsPlugin fltNotification;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
 MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   late final FirebaseMessaging _messaging;

  @override
  void initState() {
    
    registerNotification();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      home: HomePage(),
    );
  }

void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    String? token = await _messaging.getToken();
    
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
       FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    var initiizationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInit = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
     var initializationSettings = InitializationSettings(
        android: initiizationSettingsAndroid, iOS: iosInit);
   
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            // selectNotification(notificationResponse.id.toString());
            break;
          case NotificationResponseType.selectedNotificationAction:
            // if (notificationResponse.actionId == navigationActionId) {
            //   selectNotificationStream.add(notificationResponse.payload);
            // }
            break;
        }
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      var data = message.data;
      
      // AndroidNotification? android = message.notification?.android;
      if (notification != null) {

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
                iOS: DarwinNotificationDetails(
                  presentAlert: true, 
                  presentBadge: true,  
                  presentSound: true, 

                ),
                android: AndroidNotificationDetails('1', 'pushnotification',
                    channelDescription: 'Test',
                    color: Color(0xffff9d89),
                    colorized: true,
                    priority: Priority.max,
                    channelShowBadge: true,
                    importance: Importance.high,
                    playSound: true)));
      }
    });
   }
  }

   Future<String?> getToken() async {
    Future<String?> token = FirebaseMessaging.instance.getToken();
    return token;
  }

}
class PushData {
  String? id;
  String? action;

  PushData({this.id, this.action});
}