import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_testing/main.dart';
import 'package:notification_testing/print_payload_received.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  ///INITIALISATION SETTINGS START
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future init() async {
    if (Platform.isAndroid) {
      //request permission for android 13
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      //request permission for android 14 or higher
      // await flutterLocalNotificationsPlugin
      //     .resolvePlatformSpecificImplementation<
      //         AndroidFlutterLocalNotificationsPlugin>()
      //     ?.requestExactAlarmsPermission();
      await _createNotificationChannel(
          description: '', id: 'Push Notification', name: 'Push Notification');
      await _createNotificationChannel(
          description: '',
          id: 'Silent Notification',
          name: 'Silent Notification');
      await _createNotificationChannel(
          description: '',
          id: 'Default Notification',
          name: 'Default Notification');
    }

    const android =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const setting = InitializationSettings(
      android: android,
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await flutterLocalNotificationsPlugin.initialize(setting,
        onDidReceiveNotificationResponse: (payload) {
      print("Inside local notification ${payload.payload}");
      onNotifications.add(payload.payload);
      print(payload.payload ?? "");
      print("LAUNCHED VIA LOCALNAUTIFICATIONSPLUGIN.INITIALIZE");
      navigateToScreen(payload: payload.payload ?? "");
    });

    try {
      //if the app was launched via a notification
      final NotificationAppLaunchDetails? notificationAppLaunchDetails =
          await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();
      print(
          "notificationAppLaunchDetails ${notificationAppLaunchDetails?.didNotificationLaunchApp} ${notificationAppLaunchDetails?.notificationResponse?.payload}");
      if (notificationAppLaunchDetails?.didNotificationLaunchApp == true &&
          (notificationAppLaunchDetails
                  ?.notificationResponse?.payload?.isNotEmpty ??
              false)) {
        Future.delayed(const Duration(seconds: 3), () {
          print(notificationAppLaunchDetails?.notificationResponse?.payload ??
              "");
          print("LAUNCHED VIA getNotificationAppLaunchDetails");
          navigateToScreen(
              payload:
                  notificationAppLaunchDetails?.notificationResponse?.payload ??
                      "");
        });
      }
    } catch (e) {
      print("bdcsjdnfjsdbcn");
      print(e);
    }
  }

  static Future<void> _createNotificationChannel(
      {required String id,
      required String name,
      required String description}) async {
    AndroidNotificationChannel androidNotificationChannel;
    if (id.contains('Silent')) {
      androidNotificationChannel = AndroidNotificationChannel(
        id,
        name,
        description: description,
        importance: Importance.min,
        enableLights: true,
        showBadge: true,
      );
    } else if (id.contains('Default')) {
      androidNotificationChannel = AndroidNotificationChannel(
        id,
        name,
        description: description,
        importance: Importance.defaultImportance,
        playSound: true,
        enableLights: true,
        showBadge: true,
        enableVibration: true,
      );
    } else {
      androidNotificationChannel = AndroidNotificationChannel(
        id,
        name,
        description: description,
        importance: Importance.max,
        playSound: true,
        enableLights: true,
        showBadge: true,
        enableVibration: true,
      );
    }
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  static Future navigateToScreen({required String payload}) async {
    print(payload);

    Navigator.push(navigatorKey.currentState!.context,
        MaterialPageRoute(builder: (context) {
      return PrintPayloadReceived(payload: payload);
    }));
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "Notification id",
        " Notification",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableLights: true,
        icon: '@mipmap/ic_launcher',
        enableVibration: true,
        styleInformation: BigTextStyleInformation(''),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
      ),
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      flutterLocalNotificationsPlugin.show(
          id, title, body, await _notificationDetails(),
          payload: payload);
}
