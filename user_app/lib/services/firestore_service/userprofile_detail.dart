import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myapp/services/notification_service/notification_service.dart';
import 'package:myapp/widget/our_flutter_toast.dart';
import '../../controller/login_controller.dart';
import '../../db/db_helper.dart';
import '../../models/product_model.dart';
// import 'package:vibration/vibration.dart';

class UserDetailFirestore {
  var firestore = FirebaseFirestore.instance;
  uploadDetailLogin(BuildContext context) async {
    try {
      final QuerySnapshot resultQuery = await firestore
          .collection("Users")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;
      if (documentSnapshots.isEmpty) {
        print("=================== First Time =================");
        OurToast().showErrorToast("No user found");
        await FirebaseAuth.instance.currentUser!.delete();
        Navigator.pop(context);

        //9863037968 daru
        //9803030913 suyog
        //9841247987 prasan

      } else {
        print("=============== Already done ================");
        OurToast().showErrorToast("Login Successfull");
        await Hive.box<int>(DatabaseHelper.outerlayerDB).put("state", 2);
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  uploadDetailSignUp(
      String username, String number, BuildContext context) async {
    try {
      final QuerySnapshot resultQuery = await firestore
          .collection("Users")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;
      if (documentSnapshots.isEmpty) {
        print("=================== First Time =================");
        // OurToast().showErrorToast("No user found");
        // await FirebaseAuth.instance.currentUser!.delete();
        // Navigator.pop(context);
        await firestore
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "name": username,
          "AddedOn": DateFormat('yyy-MM-dd').format(
            DateTime.now(),
          ),
          "phone": number,
          "cartItems": [],
          "favorite": [],
          "cartItemNo": 0,
          "currentCartPrice": 0.0,
        });
        OurToast().showErrorToast("User registered successfully");
        await Hive.box<int>(DatabaseHelper.outerlayerDB).put("state", 2);
        Navigator.pop(context);
        Navigator.pop(context);
        //9863037968 daru
        //9803030913 suyog
        //9841247987 prasan

      } else {
        print("=============== Already done ================");
        OurToast().showErrorToast("User Already exists");
        // await Hive.box<int>(DatabaseHelper.outerlayerDB).put("state", 2);
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  addFavorite(ProductModel productModel) async {
    try {
      await FirebaseFirestore.instance
          .collection("Products")
          .doc(productModel.uid)
          .update({
        "favorite": FieldValue.arrayUnion(
          [FirebaseAuth.instance.currentUser!.uid],
        ),
      }).then(
        (value) async {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("Favorites")
              .doc(productModel.uid)
              .set(
            {"uid": productModel.uid, "timestamp": Timestamp.now()},
          ).then((value) => NotificationService().simpleBigPictureNotification(
                    "Item added to favourite list",
                    productModel.url,
                  ));
          // );

          OurToast().showSuccessToast("Added to favorite list");
        },
      );
    } catch (e) {
      OurToast().showErrorToast(e.toString());
    }
  }

  removeFavorite(ProductModel productModel) async {
    try {
      await FirebaseFirestore.instance
          .collection("Products")
          .doc(productModel.uid)
          .update(
        {
          "favorite": FieldValue.arrayRemove(
            [FirebaseAuth.instance.currentUser!.uid],
          ),
        },
      ).then((value) async {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Favorites")
            .doc(productModel.uid)
            .delete()
            .then((value) => NotificationService().simpleBigPictureNotification(
                  "Item removed from favourite list",
                  productModel.url,
                ));
        OurToast().showErrorToast("Removed from favotite list");
      });
    } catch (e) {
      OurToast().showErrorToast(e.toString());
    }
  }
}
