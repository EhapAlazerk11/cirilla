import 'dart:convert';
import 'dart:io';

import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cirilla/service/constants/preferences.dart';

SharedPreferences? sharedPref;

Future<SharedPreferences> getSharedPref() async {
  return sharedPref ?? await SharedPreferences.getInstance();
}

Future<void> _messagingBackgroundHandler(RemoteMessage message) async {
  final SharedPreferences prefs = await getSharedPref();
  List<String> messages = prefs.getStringList(Preferences.messagesKey) ?? [];
  messages.insert(
    0,
    jsonEncode({
      'messageId': message.messageId,
      'read': false,
      'sentTime': message.sentTime.toString(),
      'data': message.data,
      'notification': {'title': message.notification?.title, 'body': message.notification?.body},
    }),
  );
  await prefs.setStringList(Preferences.messagesKey, messages);
}

/// Create a [AndroidNotificationChannel] for heads up notifications
/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

/// Init Firebase service
Future<void> initializePushNotificationService() async {
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_messagingBackgroundHandler);

  if (!kIsWeb) {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

/// Update token to database
Future<void> updateTokenToDatabase(RequestHelper requestHelper, String? token) async {
  try {
    await requestHelper.updateUserToken(token);
  } catch (e) {
    print(
        '=========> Warning: Plugin Push Notifications Mobile And Web App Not Installed. Download here: https://wordpress.org/plugins/push-notification-mobile-and-web-app');
  }
}

/// Remove user token database
Future<void> removeTokenInDatabase(RequestHelper requestHelper, String? token, String? userId) async {
  await requestHelper.removeUserToken(token, userId);
}

/// Get token
Future<String?> getToken() async {
  return await FirebaseMessaging.instance.getToken();
}

/// Listening the changes
mixin MessagingMixin<T extends StatefulWidget> on State<T> {
  Future<void> subscribe(RequestHelper requestHelper, Function getMessages) async {
    if (kIsWeb || Platform.isIOS || Platform.isMacOS) {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        return;
      }
    }

    // Get the token each time the application loads
    String? token = await getToken();

    print("Token: $token");

    // Save the initial token to the database
    await updateTokenToDatabase(requestHelper, token);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen((token) => updateTokenToDatabase(requestHelper, token));

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('click to open message');
        // Navigator.pushNamed(context, '/message',
        //     arguments: MessageArguments(message, true));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      // Save message in local
      await _messagingBackgroundHandler(message);
      // Get messages
      getMessages();

      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });
  }
}
