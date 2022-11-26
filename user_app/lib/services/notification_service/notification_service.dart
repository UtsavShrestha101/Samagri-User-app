import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  static void display(RemoteMessage message) async {
    try {
      print("In Notification method");
      print("=============");
      print(message.data);
      print("=============");
      // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
      Random random = new Random();
      int id = random.nextInt(1000);

      try {
        print("Utsav Shrestha Utkrisa Shrestha");

        // if (message.data["senderImage"] == "") {
        //   print("Emptyyyyyyyyyyy");
        try {
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: id,
              channelKey: "Basic_channel",
              title: message.data["title"],
              body: message.data['body'],
              // icon: message.data["senderImage"],

              bigPicture: message.data["imageUrl"],
              largeIcon: message.data["senderImage"],
              notificationLayout: NotificationLayout.BigPicture,
            ),
          );
        } catch (e) {
          print("=============");
          print(e);
          print("=============");
        }
      } catch (e) {
        print("===========");
      }
    } on Exception catch (e) {
      print('Error>>>$e');
    }
  }

  sendNotification(String title, String body, String senderImage,
      String imageUrl, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'title': title,
      'body': body,
      "senderImage":
          "https://firebasestorage.googleapis.com/v0/b/ride-sharing-app-1.appspot.com/o/icon.png?alt=media&token=536de3d8-e86a-42a8-aef3-25abba6b5ac0",
      // ??
      // "https://firebasestorage.googleapis.com/v0/b/bytereels-2ee4d.appspot.com/o/profile_holder.png?alt=media&token=170d398a-10b4-4fbb-a27f-c70d58b4e1b0",
      // "imageUrl":imageUrl,
      // "https://firebasestorage.googleapis.com/v0/b/ride-sharing-app-1.appspot.com/o/316174694_1819029891811122_7951309001294571441_n.png?alt=media&token=8196ddc7-be51-4098-a86d-3cfa349ec7ac",
    };
    print("=================");
    print(token);
    print("=================");

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAXGOoPNo:APA91bHPDZIThVI2ilypWwNNRyOrsRCLvVPvsOfen0UR0l5OkSN9pOG6R1rEQ--gxPP9LcY8_ZBaUia6XPW1MfEV6p_fhIb6MWjSK3oEHa5BRJygb39wpB5yhJjs1z8erlpdLlhrOsBw'
              },
              body: jsonEncode(<String, dynamic>{
                // 'notification': <String, dynamic>{
                //   'title': title,
                //   'body': body,
                // },
                'priority': 'high',
                'data': data,
                'to': token,
              }));

      if (response.statusCode == 200) {
        print("Yeh notificatin is sended");
        print(response.body);
      } else {
        print("Error");
      }
    } catch (e) {
      print("Error occured");
      print("=======");
      print(e.toString());
      print("=======");
    }
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
