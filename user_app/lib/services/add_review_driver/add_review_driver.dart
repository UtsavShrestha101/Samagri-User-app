import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../models/driver_model.dart';
import '../notification_service/notification_service.dart';

class AddReviewDriver {
  addReview(DriverModel driverModel, String review) async {
    var reviewUID = Uuid().v4();
    var a = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    await FirebaseFirestore.instance
        .collection("AllReviews")
        .doc(reviewUID)
        .set({
          "senderName":a.data()!["name"],
      "senderUID": FirebaseAuth.instance.currentUser!.uid,
      "driverUID": driverModel.uid,
      "reviewUID": reviewUID,
      "review": review,
      "created_On": Timestamp.now()
    });
    await FirebaseFirestore.instance
        .collection("Drivers")
        .doc(driverModel.uid)
        .update({
      "reviews": driverModel.reviews! + 1,
    });
    await NotificationService().sendNotification(
      "You got a review",
      review,
      "userModel.profile_pic",
      "",
      driverModel.token!,
    );
  }
}
