import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../controller/check_out_screen_controller.dart';
import '../../controller/delivery_time_controller.dart';
import '../../controller/login_controller.dart';

class PlaceOrderService {
  submitOrder(
      List<Map<String, dynamic>> itemModel, double total, String type) async {
    print("Inside submit order");
    var uid = Uuid().v4();
    try {
      var userData = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Map<String, dynamic> mapss = {
        "status": "In Progress",
        "userPhoneNo": userData["phone"],
        "uid": uid,
        "isDelivered": false,
        "driverUid": "",
        "verifyToken": Random().nextInt(900000) + 100000,
        "totalPrice": total,
        "paymentType": type,
        "deliveryTime": Get.find<DeliveryTimeController>().shippingTime.value,
        "deliveryAddress": Get.find<CheckOutScreenController>().address.value,
        "items": itemModel,
        "orderedAt": Timestamp.now(),
      };
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("MyOrders")
          .doc(uid)
          .set(mapss)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "currentCartPrice": 0.0,
          "cartItemNo": 0,
          "cartItems": [],
        });
        var collection = await FirebaseFirestore.instance
            .collection("Carts")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Products");
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          await doc.reference.delete();
        }
      });
      Get.find<LoginController>().toggle(false);

      // print(mapss);
    } catch (e) {
      Get.find<LoginController>().toggle(false);

      print(e);
    }
  }
}
