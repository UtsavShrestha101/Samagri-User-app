import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/notification_service/notification_service.dart';

import '../../models/driver_model.dart';
import '../../models/user_model_firebase.dart';

class ChatDetailFirebase {
  messageDetail(String message, UserModel userModel,
      FirebaseUser11Model firebaseUser11Model) async {
    print("MESSAGE DETAIL SCREEN");
    print("MESSAGE DETAIL SCREEN");
    print("MESSAGE DETAIL SCREEN");
    try {
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(userModel.uid)
          .set({"timestamp": Timestamp.now(), "uid": userModel.uid});
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          //Chatroom ->currentuid ->chat -prasanid -> messages ->[]
          //Chatroom ->prasanuid ->chat -currentid -> messages ->[]
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(userModel.uid)
          .collection("Messages")
          .add({
        "message": message,
        "type": "text",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": userModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(userModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "timestamp": Timestamp.now(),
        "uid": FirebaseAuth.instance.currentUser!.uid,
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(userModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Messages")
          .add({
        "message": message,
        "type": "text",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": userModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });
      // var a = await FirebaseFirestore.instance
      //     .collection("Users")
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .get();
      // FirebaseUser11Model userModel11 = FirebaseUser11Model.fromMap(a);
      // print(userModel.name);
      await NotificationService().sendNotification(
        "${firebaseUser11Model.name} messaged you",
        message,
        "userModel.profile_pic",
        "",
        userModel.token,
      );

      // print("Doneee sending message");
    } catch (e) {}
  }

 drivermessageDetail(String message, DriverModel driverModel,
      FirebaseUser11Model firebaseUser11Model) async {
    print("MESSAGE DETAIL SCREEN");
    print("MESSAGE DETAIL SCREEN");
    print("MESSAGE DETAIL SCREEN");
    try {
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(driverModel.uid)
          .set({"timestamp": Timestamp.now(), "uid": driverModel.uid});
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          //Chatroom ->currentuid ->chat -prasanid -> messages ->[]
          //Chatroom ->prasanuid ->chat -currentid -> messages ->[]
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(driverModel.uid)
          .collection("Messages")
          .add({
        "message": message,
        "type": "text",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": driverModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(driverModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "timestamp": Timestamp.now(),
        "uid": FirebaseAuth.instance.currentUser!.uid,
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(driverModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Messages")
          .add({
        "message": message,
        "type": "text",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": driverModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });
      // var a = await FirebaseFirestore.instance
      //     .collection("Users")
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .get();
      // FirebaseUser11Model userModel11 = FirebaseUser11Model.fromMap(a);
      // print(userModel.name);
      await NotificationService().sendNotification(
        "${firebaseUser11Model.name} messaged you",
        message,
        "userModel.profile_pic",
        "",
        driverModel.token!,
      );

      // print("Doneee sending message");
    } catch (e) {}
  }

  imageDetail(String downloadUrl, UserModel userModel,
      FirebaseUser11Model userl111) async {
    try {
      print("IMAGE DETAIL");
      print(downloadUrl);
      print("IMAGE DETAIL");

      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(userModel.uid)
          .set({"timestamp": Timestamp.now(), "uid": userModel.uid});

      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(userModel.uid)
          .collection("Messages")
          .add({
        "message": downloadUrl,
        "type": "image",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": userModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(userModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "timestamp": Timestamp.now(),
        "uid": FirebaseAuth.instance.currentUser!.uid,
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(userModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Messages")
          .add({
        "message": downloadUrl,
        "type": "image",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": userModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });
      await NotificationService().sendNotification(
          "${userl111.name} messaged you",
          "",
          "userModel.profile_pic",
          downloadUrl,
          userModel.token);
      print("Doneee sending message");
    } catch (e) {
      print("object");
    }
  }
}
