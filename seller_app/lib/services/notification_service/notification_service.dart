import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  void initialize() {
    print("Inside Notification initialization");
    AwesomeNotifications().initialize(
      "resource://drawable/icon",
      [
        NotificationChannel(
          channelKey: "Basic_channel",
          channelName: "Basic notification",
          channelDescription: "Channel Desc1",
          ledColor: Colors.teal,
          enableLights: true,
          enableVibration: true,
          soundSource: "resource://raw/notification_sound",
          playSound: true,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
    );
  }

  Future<void> simpleBigPictureNotification(String title, String url) async {
    Random random = new Random();
    int id = random.nextInt(1000);
    try {
      await AwesomeNotifications()
          .createNotification(
              content: NotificationContent(
            id: id,
            channelKey: "Basic_channel",
            title: title,
            bigPicture: url,
            notificationLayout: NotificationLayout.BigPicture,
          ))
          .then(
            (value) => print("Notification sent"),
          );
    } catch (e) {
      print("==============");
      print("==============");
      print(e);
      print("==============");
      print("==============");
    }
  }
  Future<void> simpleNotification(String title) async {
    Random random = new Random();
    int id = random.nextInt(1000);
    try {
      await AwesomeNotifications()
          .createNotification(
              content: NotificationContent(
            id: id,
            channelKey: "Basic_channel",
            title: title,
            // bigPicture: url,
            // notificationLayout: NotificationLayout.BigPicture,
          ))
          .then(
            (value) => print("Notification sent"),
          );
    } catch (e) {
      print("==============");
      print("==============");
      print(e);
      print("==============");
      print("==============");
    }
  }
}
