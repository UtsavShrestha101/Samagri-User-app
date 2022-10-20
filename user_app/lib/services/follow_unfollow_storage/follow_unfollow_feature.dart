import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/seller_model.dart';
import 'package:myapp/models/user_model.dart';
// import 'package:myapp/services/local_push_notification/local_push_notification.dart';

class FollowUnfollowDetailFirebase {
  follow(FirebaseSellerModel userModel) async {
    print("Inside follow");
    try {
      // UserModel followeruserModel = UserModel.fromMap(await FirebaseFirestore
      //     .instance
      //     .collection("Users")
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .get());

      DocumentSnapshot abc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      await FirebaseFirestore.instance
          .collection("Sellers")
          .doc(userModel.uid)
          .update({
        "followerList":
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        "follower": userModel.follower + 1,
      });

      // await FirebaseFirestore.instance
      //     .collection("Notification")
      //     .doc(userModel.uid)
      //     .collection("Notify")
      //     .doc(followeruserModel.uid)
      //     .set({
      //   "senderId": followeruserModel.uid,
      //   "post_pic": "",
      //   "postId": "",
      //   "timestamp": Timestamp.now(),
      //   "senderProfile": followeruserModel.profile_pic,
      //   "comment": "",
      //   "type": "follow",
      //   "senderName": followeruserModel.user_name,
      // });

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "followingList": FieldValue.arrayUnion([userModel.uid]),
        "following": abc["following"] + 1,
      });
      // await LocalNotificationService().sendNotification(
      //     "${followeruserModel.user_name} started following you",
      //     "",
      //     followeruserModel.profile_pic,
      //     "",
      //     userModel.token);
    } catch (e) {
      print(e);
    }
  }

  unfollow(FirebaseSellerModel userModel) async {
    // UserModel followeruserModel = UserModel.fromMap(await FirebaseFirestore
    //     .instance
    //     .collection("Users")
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .get());
     DocumentSnapshot abc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();


    await FirebaseFirestore.instance
        .collection("Sellers")
        .doc(userModel.uid)
        .update({
      "followerList": FieldValue.arrayRemove([abc['uid']]),
      "follower": userModel.follower - 1,
    });

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "followingList": FieldValue.arrayRemove([userModel.uid]),
      "following": abc["following"]  - 1,
    });
    // try {
    //   await FirebaseFirestore.instance
    //       .collection("ChatRoom")
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .collection("Chat")
    //       .doc(userModel.uid)
    //       .collection("Messages")
    //       .get()
    //       .then((snapshot) async {
    //     for (DocumentSnapshot doc in snapshot.docs) {
    //       await doc.reference.delete();
    //       print("======");
    //       print(doc);
    //     }
    //   });

    //   await FirebaseFirestore.instance
    //       .collection("ChatRoom")
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .collection("Chat")
    //       .doc(userModel.uid)
    //       .delete();

    //   // .delete()
    //   // .then((value) => print("DELETED FIRST"));
    // } catch (e) {
    //   print("==========");
    //   print(e.toString());
    //   print("==========");
    // }
    // try {
    //   await FirebaseFirestore.instance
    //       .collection("ChatRoom")
    //       .doc(userModel.uid)
    //       .collection("Chat")
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .collection("Messages")
    //       .get()
    //       .then((snapshot) async {
    //     for (DocumentSnapshot doc in snapshot.docs) {
    //       await doc.reference.delete();
    //       print("======");
    //       print(doc);
    //     }
    //   });
    //   await FirebaseFirestore.instance
    //       .collection("ChatRoom")
    //       .doc(userModel.uid)
    //       .collection("Chat")
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .delete();
    // } catch (e) {
    //   print("==========");
    //   print(e.toString());
    //   print("==========");
    // }

    print("Geda Done=================");
  }
}
