import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ca_appoinment/app/const/push_service_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PushNotificationService {
  static FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final onClickNotification = BehaviorSubject<String>();
  static void onNotificationTapBackgournd(NotificationResponse res) {
    onClickNotification.add(res.payload!);
  }

  static void handleNavigtion(BuildContext context) {}

  static void initialize() {
    const initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    notificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse res) {
      onClickNotification.add(res.payload!);
      // handleNavigtion(context);
    }, onDidReceiveBackgroundNotificationResponse: onNotificationTapBackgournd);
  }

  static void createNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            'CaNotification', 'CA Notifications',
            importance: Importance.high, priority: Priority.high),
        iOS: DarwinNotificationDetails(),
      );
      await notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  static void secduleNotification(RemoteMessage message, int time) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'CaNotification',
          'CA Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );

      tz.initializeTimeZones();

      var tzTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, time);
      await notificationsPlugin.zonedSchedule(id, message.notification!.title,
          message.notification!.body, tzTime, notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.wallClockTime);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  static Future<RemoteMessage?> registerNotification() async {
    await Firebase.initializeApp();
    late FirebaseMessaging messaging;

    RemoteMessage? message;
    messaging = FirebaseMessaging.instance;
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings settings = await messaging.requestPermission(
      badge: true,
      sound: true,
      alert: true,
      provisional: false,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage newMsg) {
        message = newMsg;
      });
    } else {
      return null;
    }
    return message;
  }

  static Future<RemoteMessage?> checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initMessage != null) {
      return initMessage;
    }
    return null;
  }

// ================ Get The Access Token ==================//
  static Future<String> getAccessToken() async {
    final serviceAccountJson = auth.ServiceAccountCredentials.fromJson(
        PushServiceConst.serviceAccount);

    final scopes = PushServiceConst.scopes;
    http.Client client =
        await auth.clientViaServiceAccount(serviceAccountJson, scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            serviceAccountJson, scopes, client);
    client.close();
    return credentials.accessToken.data;
  }

  static sendNotificationToSelectedUser(
      String deviceToken, RemoteMessage data) async {
    final String serverAccessTokenKey = await getAccessToken();

    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': data.notification!.title,
          'body': data.notification!.body
        },
        'data': data.data
      }
    };
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverAccessTokenKey'
    };
    http.Response respone = await http.post(Uri.parse(PushServiceConst.apiUrl),
        headers: header, body: jsonEncode(message));

    if (respone.statusCode == 200) {
    } else {
    }
  }
}
