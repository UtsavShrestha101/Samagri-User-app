import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/cart_product_model.dart';
import 'package:myapp/services/notification_service/notification_service.dart';
import 'package:uuid/uuid.dart';

import '../../controller/dashboard_controller.dart';
import '../../controller/login_controller.dart';
import '../../models/firebase_user_model.dart';
import '../../models/product_model.dart';
import '../../widget/our_flutter_toast.dart';

class ProductDetailFirestore {
  AddProduct(
    List<String> pickedImagessUrl,
    String name,
    String desc,
    int quantity,
    double price,
    String categoryItem,
  ) async {
    List<String> searchList = [];
    for (int i = 0; i <= name.length; i++) {
      searchList.add(
        name.substring(0, i).toLowerCase(),
      );
    }
    String uid = const Uuid().v4();
    try {
      await FirebaseFirestore.instance.collection("All").doc(uid).set({
        "uid": uid,
        "name": name,
        "desc": desc,
        "price": price,
        "rating": 0.0,
        "url": pickedImagessUrl,
        "addedOn": DateFormat('yyy-MM-dd').format(
          DateTime.now(),
        ),
        "ratingUID": [],
        "ratingNo": 0,
        "timestamp": Timestamp.now(),
        "favorite": [],
        "searchfrom": searchList,
        "category": [
          "All",
          categoryItem,
        ],
      }).then((value) {
        Get.find<DashboardController>().changeIndexs(0);
        OurToast().showSuccessToast("Product added");
      });
      Get.find<LoginController>().toggle(false);
    } catch (e) {
      Get.find<LoginController>().toggle(false);

      OurToast().showErrorToast(e.toString());
    }
  }

  deleteItemFromCart(CartProductModel cartProductModel) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      var cartItemNo = data.data()!["cartItemNo"];
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "cartItems": FieldValue.arrayRemove([cartProductModel.uid]),
        "cartItemNo": cartItemNo - 1,
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection("Carts")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Products")
            .doc(cartProductModel.uid)
            .delete();
        var data = await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        var currentCartPrice = data.data()!["currentCartPrice"];
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "currentCartPrice": currentCartPrice -
              cartProductModel.price * cartProductModel.quantity,
        }).then(
          (value) => NotificationService().simpleBigPictureNotification(
            "Item removed from cart",
            cartProductModel.url,
          ),
        );
        OurToast().showSuccessToast("Product removed from cart");
      });
    } catch (e) {
      OurToast().showErrorToast(e.toString());
    }
  }

  addItemToCart(FirebaseUserModel firebaseUserModel, ProductModel product,
      int quantity) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "cartItems": FieldValue.arrayUnion([product.uid]),
        "cartItemNo": firebaseUserModel.cartItemNo + 1,
        "currentCartPrice":
            firebaseUserModel.currentCartPrice + product.price * quantity
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection("Carts")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Products")
            .doc(product.uid)
            .set({
          "uid": product.uid,
          "name": product.name,
          "desc": product.desc,
          "url": product.url,
          "price": product.price,
          "addedOn": Timestamp.now(),
          "quantity": quantity,
        }).then((value) => NotificationService().simpleBigPictureNotification(
                "Item added to cart", product.url[0]));

        OurToast().showSuccessToast("Product Added to cart");
      });
    } catch (e) {
      OurToast().showErrorToast(e.toString());
    }
  }

  addReview(String review, String productId, String name) async {
    String uid = const Uuid().v4();
    try {
      await FirebaseFirestore.instance
          .collection("Products")
          .doc(productId)
          .collection("Reviews")
          .doc(uid)
          .set({
        "uid": uid,
        "senderName": name,
        "senderId": FirebaseAuth.instance.currentUser!.uid,
        "review": review,
        "timestamp": Timestamp.now(),
      });
    } catch (e) {
      OurToast().showErrorToast(
        e.toString(),
      );
    }
  }

  addRating(ProductModel product, double rating) async {
    try {
      await FirebaseFirestore.instance
          .collection("Rating")
          .doc(product.uid)
          .collection("Ratings")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({"rating": rating}).then(
        (value) => print("Inside Add rating function done"),
      );
    } catch (e) {}
  }

  updateRatingNo(ProductModel product) async {
    try {
      await FirebaseFirestore.instance
          .collection("Products")
          .doc(product.uid)
          .update({
        "ratingUID":
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        "ratingNo": product.ratingNo + 1,
      }).then((value) => print("Inside UpdateRatingNo done"));
    } catch (e) {}
  }

  updateProductRating(ProductModel product) async {
    double finalRating = 0.0;
    int totalNum = 0;
    QuerySnapshot abc = await FirebaseFirestore.instance
        .collection("Rating")
        .doc(product.uid)
        .collection("Ratings")
        .get();

    abc.docs.forEach((element) {
      finalRating = finalRating + element["rating"];
    });

    var b = await FirebaseFirestore.instance
        .collection("Products")
        .doc(product.uid)
        .get();
    totalNum = b["ratingNo"];
    try {
      await FirebaseFirestore.instance
          .collection("Products")
          .doc(product.uid)
          .update({"rating": finalRating / totalNum}).then(
              (value) => print("Inside UpdateRatingNo done"));
    } catch (e) {}
  }

  removeItemFromCart(
      FirebaseUserModel firebaseUserModel, ProductModel product) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "cartItems": FieldValue.arrayRemove([product.uid]),
        "cartItemNo": firebaseUserModel.cartItemNo - 1,
      }).then((value) async {
        var abc = await FirebaseFirestore.instance
            .collection("Carts")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Products")
            .doc(product.uid)
            .get();
        CartProductModel cartProductModel = CartProductModel.fromMap(abc);
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "currentCartPrice": firebaseUserModel.currentCartPrice -
              cartProductModel.price * cartProductModel.quantity,
        });
        try {
          await FirebaseFirestore.instance
              .collection("Carts")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("Products")
              .doc(product.uid)
              .delete()
              .then(
                (value) => NotificationService().simpleBigPictureNotification(
                  "Item removed from cart",
                  product.url[0],
                ),
              );
        } catch (e) {
          print("==========");
          print(e);
          print("==========");
        }

        OurToast().showSuccessToast("Product removed from cart");
      });
    } catch (e) {
      OurToast().showErrorToast(e.toString());
    }
  }

  increaseProductCount(CartProductModel cartProductModel) async {
    double totalPrice = 0.0;
    await FirebaseFirestore.instance
        .collection("Carts")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Products")
        .doc(cartProductModel.uid)
        .update({
      "quantity": cartProductModel.quantity + 1,
    }).then((value) async {
      var collection = await FirebaseFirestore.instance
          .collection("Carts")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Products")
          .get();
      for (var doc in collection.docs) {
        var abc = doc.data();
        CartProductModel cartProductModel =
            CartProductModel.toIncreaseorDecrease(doc.data());
        totalPrice =
            totalPrice + cartProductModel.price * cartProductModel.quantity;
      }
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"currentCartPrice": totalPrice});
    });
  }

  decreaseProductCount(CartProductModel cartProductModel) async {
    await HapticFeedback.vibrate();

    double totalPrice = 0.0;

    await FirebaseFirestore.instance
        .collection("Carts")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Products")
        .doc(cartProductModel.uid)
        .update({
      "quantity": cartProductModel.quantity - 1,
    }).then((value) async {
      var collection = await FirebaseFirestore.instance
          .collection("Carts")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Products")
          .get();
      for (var doc in collection.docs) {
        var abc = doc.data();
        CartProductModel cartProductModel =
            CartProductModel.toIncreaseorDecrease(doc.data());
        totalPrice =
            totalPrice + cartProductModel.price * cartProductModel.quantity;
      }
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        {
          "currentCartPrice": totalPrice,
        },
      );
    });
  }
}
