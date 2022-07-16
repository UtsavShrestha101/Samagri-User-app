import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myapp/services/notification_service/notification_service.dart';
import 'package:myapp/widget/our_flutter_toast.dart';
import 'package:uuid/uuid.dart';
import '../../controller/login_controller.dart';

class Location {
  AddLocation(
    String Whole_Address,
    String administrative_area_level,
    String administrative_area_level_2,
    String locality,
    String sublocality,
    double? long,
    double? lat,
  ) async {
    print("Inside Add location");
    try {
      var uid = Uuid().v4();
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Location")
          .doc(uid)
          .set(
        {
          "uid": uid,
          "administrative_area": administrative_area_level,
          "administrative_area2": administrative_area_level_2,
          "locality": locality,
          "sublocality": sublocality,
          "full_address": Whole_Address,
          "longitude": long,
          "latitude": lat,
          "timestamp": Timestamp.now(),
        },
      ).then((value) {
        NotificationService().simpleNotification("New delivery address added");
        OurToast().showErrorToast("New delivery address added");
      });
    } catch (e) {
      print("============");
      print(e);
      print("============");
    }
  }

  deleteLocation(String uid) {
    try {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Location")
          .doc(uid)
          .delete()
          .then((value) {
        NotificationService()
            .simpleNotification("Delivery address has been deleted");
        OurToast().showErrorToast("Location deleted");
      });
    } catch (e) {
      print(e);
    }
  }
}
