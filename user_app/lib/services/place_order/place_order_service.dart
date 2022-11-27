import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:myapp/widget/our_flutter_toast.dart';
import 'package:uuid/uuid.dart';

import '../../controller/check_out_screen_controller.dart';
import '../../controller/delivery_time_controller.dart';
import '../../controller/login_controller.dart';
import '../../models/user_model.dart';
import '../notification_service/notification_service.dart';

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
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "status": "In Progress",
        "userPhoneNo": userData["phone"],
        "uid": uid,
        "isDelivered": false,
        "driverUid": "",
        "driverName": "",
        "verifyToken": Random().nextInt(900000) + 100000,
        "totalPrice": total,
        "paymentType": type,
        "deliveryTime": Get.find<DeliveryTimeController>().shippingTime.value,
        "deliveryAddress": Get.find<CheckOutScreenController>().address.value,
        "lat": Get.find<CheckOutScreenController>().lat.value,
        "long": Get.find<CheckOutScreenController>().long.value,
        "items": itemModel,
        "orderedAt": Timestamp.now(),
        "deliveredAt": Timestamp.now(),
      };

      itemModel.forEach((element) async {
        var requestProductId = Uuid().v4();
        await FirebaseFirestore.instance
            .collection("RequestOrder")
            .doc(element["ownerId"])
            .collection("Requests")
            .doc(requestProductId)
            .set(
          {
            "requestedOn": Timestamp.now(),
            "batchId": uid,
            "requestUserId": FirebaseAuth.instance.currentUser!.uid,
            "requestId": requestProductId,
            "productId": element["productId"],
            "price": element["price"],
            "quantity": element["quantity"],
            "productImage": element["uid"],
            "ispicked": false,
            "productName": element["name"],
          },
        );
        var a = await FirebaseFirestore.instance
            .collection("Sellers")
            .doc(element["ownerId"])
            .get();
        UserModel userModel = UserModel.fromMap(a);
        await NotificationService().sendNotification(
            "Order request",
            "${element["name"]} is requested",
            "userModel.profile_pic",
            "",
            userModel.token);
      });
      await FirebaseFirestore.instance
          .collection("Orders")
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
      OurToast().showSuccessToast("Order Placed");
      // print(mapss);
    } catch (e) {
      Get.find<LoginController>().toggle(false);

      print(e);
    }
  }
}
