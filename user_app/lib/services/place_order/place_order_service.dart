import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:myapp/widget/our_flutter_toast.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../../controller/check_out_screen_controller.dart';
import '../../controller/delivery_time_controller.dart';
import '../../controller/login_controller.dart';
import '../../models/user_model.dart';
import '../notification_service/notification_service.dart';

class PlaceOrderService {
  submitOrder(
      List<Map<String, dynamic>> itemModel, double total, String type) async {
    print("Inside submit order");
    List<String> productIDSlist = [];
    var uid11 = Uuid().v4();
    try {
      var userData = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      itemModel.forEach((element) async {
        var requestProductId = Uuid().v4();
        productIDSlist.add(requestProductId);
        await FirebaseFirestore.instance
            .collection("RequestOrder")
            .doc(requestProductId)
            .set(
          {
            "productOwnerId": element["ownerId"],
            "requestedOn": Timestamp.now(),
            "batchId": uid11,
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
        var uniqueNotificationUId = Uuid().v4();
        //notificaiton ->piuid ->motificauir -
        await FirebaseFirestore.instance
            .collection("Notifications")
            .doc(element["ownerId"])
            .collection("MyNotifications")
            .doc(uniqueNotificationUId)
            .set({
          "uid": uniqueNotificationUId,
          "productName": element["name"],
          "productImage": element["uid"],
          "senderName": userData["name"],
          "desc": "Item requested",
          "addedOn": Timestamp.now(),
        });
      });
      int verifyToken = Random().nextInt(900000) + 100000;
      Map<String, dynamic> mapss = {
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "status": "In Progress",
        "userPhoneNo": userData["phone"],
        "uid": uid11,
        "isDelivered": false,
        "driverUid": "",
        "driverName": "",
        "verifyToken": verifyToken,
        "totalPrice": total,
        "paymentType": type,
        "deliveryTime": Get.find<DeliveryTimeController>().shippingTime.value,
        "deliveryAddress": Get.find<CheckOutScreenController>().address.value,
        "lat": Get.find<CheckOutScreenController>().lat.value,
        "long": Get.find<CheckOutScreenController>().long.value,
        "items": productIDSlist,
        "orderedAt": Timestamp.now(),
        "deliveredAt": Timestamp.now(),
      };
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(uid11)
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
      print("=========================");
      print("=========================");
      print("=========================");
      print("=========================");
      print("=========================");
      String mainurl =
          "https://bulk.bedbyaspokhrel.com.np/smsapi/index.php?key=4633085F44E5F1&campaign=7022&routeid=195&type=text&contacts=${userData["phone"]}&senderid=adf121bgaad&msg=Dear valuable customer (${userData["name"]}), your order has been placed.\nOrderId = ${uid11}.\nVerification OTP = ${verifyToken}\nWe appreciate your time.\nGo Mart\nPowered by: Harambe Gople Studio.\nhttps://play.google.com/store/apps/details?id=com.userApp.first123";
      final response = await http.get(
        Uri.parse(mainurl),
      );
      if (response.statusCode == 200) {
        print("Inside code 200");
        print(response.body);
      } else {
        print("Inside code ${response.statusCode}");
        print(response.body);
      }

      Get.find<LoginController>().toggle(false);
      OurToast().showSuccessToast("Order Placed");
      // print(mapss);
    } catch (e) {
      Get.find<LoginController>().toggle(false);

      print(e);
    }
  }
}
