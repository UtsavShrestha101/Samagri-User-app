// import 'package:esewa_pnp/esewa.dart';
// import 'package:esewa_pnp/esewa_pnp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:myapp/models/user_model_firebase.dart';
import 'package:myapp/services/place_order/place_order_service.dart';
import 'package:uuid/uuid.dart';
// import 'package:esewa_pnp/esewa_pnp.dart';
import '../../controller/check_out_screen_controller.dart';
import '../../controller/delivery_time_controller.dart';
import '../../controller/login_controller.dart';
import '../../models/cart_product_model.dart';
import '../../models/checkout_product_model.dart';
import '../../models/firebase_user_model.dart';
import '../../services/network_connection/network_connection.dart';
import '../../utils/color.dart';
import '../../widget/our_flutter_toast.dart';
import '../../widget/our_sized_box.dart';

class CheckOutPaymentScreen extends StatefulWidget {
  final double totalPrice;
  const CheckOutPaymentScreen({Key? key, required this.totalPrice})
      : super(key: key);

  @override
  State<CheckOutPaymentScreen> createState() => _CheckOutPaymentScreenState();
}

class _CheckOutPaymentScreenState extends State<CheckOutPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OurSizedBox(),
          Text(
            "Selected delivery address and scheduled time:",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(17.5),
              color: darklogoColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          OurSizedBox(),
          FxContainer.bordered(
            color: logoColor.withOpacity(0.2),
            border: Border.all(color: darklogoColor),
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(2.5),
              vertical: ScreenUtil().setSp(2.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  Get.find<CheckOutScreenController>().address.value,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14.5),
                    color: darklogoColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                OurSizedBox(),
                Text(
                  Get.find<DeliveryTimeController>().shippingTime.value,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14.5),
                    color: darklogoColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          OurSizedBox(),
          Text(
            "Select Payment method:",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(17.5),
              color: darklogoColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          OurSizedBox(),
          Row(
            children: [
              Expanded(
                // flex: 2,
                child: InkWell(
                  onTap: () {
                    Get.find<CheckOutScreenController>().changepaymentIndex(0);
                  },
                  child: Container(
                    height: ScreenUtil().setSp(70),
                    decoration: BoxDecoration(
                      color: Get.find<CheckOutScreenController>()
                                  .paymentIndex
                                  .value ==
                              0
                          ? logoColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setSp(10),
                      ),
                      border: Border.all(
                        color: Get.find<CheckOutScreenController>()
                                    .paymentIndex
                                    .value ==
                                0
                            ? darklogoColor
                            : logoColor,
                      ),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setSp(2.5),
                      vertical: ScreenUtil().setSp(2.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Cash on delivery",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(14.5),
                            color: darklogoColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Get.find<CheckOutScreenController>()
                                    .paymentIndex
                                    .value ==
                                0
                            ? Center(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: ScreenUtil().setSp(2.5),
                                  ),
                                  // padding: EdgeInsets.all(
                                  //   ScreenUtil().setSp(
                                  //     2.5,
                                  //   ),
                                  // ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: darklogoColor,
                                      ),
                                      color: darklogoColor),
                                  child: Icon(
                                    Icons.check,
                                    size: ScreenUtil().setSp(17.5),
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.find<CheckOutScreenController>().changepaymentIndex(1);
                  },
                  child: Container(
                    height: ScreenUtil().setSp(70),
                    decoration: BoxDecoration(
                      color: Get.find<CheckOutScreenController>()
                                  .paymentIndex
                                  .value ==
                              1
                          ? logoColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setSp(10),
                      ),
                      border: Border.all(
                        color: Get.find<CheckOutScreenController>()
                                    .paymentIndex
                                    .value ==
                                1
                            ? darklogoColor
                            : logoColor,
                      ),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setSp(2.5),
                      vertical: ScreenUtil().setSp(2.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Khalti",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(14.5),
                            color: darklogoColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Get.find<CheckOutScreenController>()
                                    .paymentIndex
                                    .value ==
                                1
                            ? Center(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: ScreenUtil().setSp(2.5),
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: darklogoColor,
                                      ),
                                      color: darklogoColor),
                                  child: Icon(
                                    Icons.check,
                                    size: ScreenUtil().setSp(17.5),
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.find<CheckOutScreenController>().changepaymentIndex(2);
                  },
                  child: Container(
                    height: ScreenUtil().setSp(70),
                    decoration: BoxDecoration(
                      color: Get.find<CheckOutScreenController>()
                                  .paymentIndex
                                  .value ==
                              2
                          ? logoColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setSp(10),
                      ),
                      border: Border.all(
                        color: Get.find<CheckOutScreenController>()
                                    .paymentIndex
                                    .value ==
                                2
                            ? darklogoColor
                            : logoColor,
                      ),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setSp(2.5),
                      vertical: ScreenUtil().setSp(2.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Esewa",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(14.5),
                            color: darklogoColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Get.find<CheckOutScreenController>()
                                    .paymentIndex
                                    .value ==
                                2
                            ? Center(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: ScreenUtil().setSp(2.5),
                                  ),
                                  // padding: EdgeInsets.all(
                                  //   ScreenUtil().setSp(
                                  //     2.5,
                                  //   ),
                                  // ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: darklogoColor,
                                      ),
                                      color: darklogoColor),
                                  child: Icon(
                                    Icons.check,
                                    size: ScreenUtil().setSp(17.5),
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          OurSizedBox(),
          FxButton.block(
            onPressed: () async {
              print("Minus buttom pressed");
              if (Get.find<CheckConnectivity>().isOnline == false) {
                OurToast().showErrorToast("Oops, No internet connection");
              } else {
                // await ProductDetailFirestore()
                //     .deleteItemFromCart(widget.cartProductModel);

                Get.find<LoginController>().toggle(true);
                var uid = Uuid().v4();
                if (Get.find<CheckOutScreenController>().paymentIndex.value ==
                    0) {
                  print("Cash On Delivery");
                  List<Map<String, dynamic>> itemModel = [];
                  var userData = await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get();
                  // FirebaseUserModel firebaseUserModel =FirebaseUser11Model.fromMap(userData);
                  var collection = await FirebaseFirestore.instance
                      .collection("Carts")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("Products")
                      .get();
                  for (var doc in collection.docs) {
                    var abc = doc.data();
                    CartProductModel cartProductModel =
                        CartProductModel.toIncreaseorDecrease(doc.data());

                    itemModel.add(
                      CheckOutProductModel(
                        ownerId: cartProductModel.ownerId,
                        name: cartProductModel.name,
                        quantity: cartProductModel.quantity,
                        price: cartProductModel.price,
                        uid: cartProductModel.url[0],
                        isPacked: false,
                      ).toMap(),
                    );
                  }
                  PlaceOrderService().submitOrder(
                    itemModel,
                    widget.totalPrice,
                    "Cash on Delivery",
                  );
                  Get.find<CheckOutScreenController>().changeIndex(2);
                } else if (Get.find<CheckOutScreenController>()
                        .paymentIndex
                        .value ==
                    1) {
                  print(uid);
                  print("Khalti");
                  KhaltiScope.of(context).pay(
                    config: PaymentConfig(
                      amount: widget.totalPrice.toInt() * 100,
                      productIdentity: uid,
                      productName: 'Samagri-User TrackingID -$uid',
                    ),
                    preferences: [
                      PaymentPreference.khalti,
                      PaymentPreference.connectIPS,
                      PaymentPreference.eBanking,
                      PaymentPreference.sct,
                      PaymentPreference.mobileBanking,
                    ],
                    onSuccess: (su) async {
                      print("Cash On Delivery");
                      List<Map<String, dynamic>> itemModel = [];
                      var userData = await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get();
                      // FirebaseUserModel firebaseUserModel =FirebaseUser11Model.fromMap(userData);
                      var collection = await FirebaseFirestore.instance
                          .collection("Carts")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("Products")
                          .get();
                      for (var doc in collection.docs) {
                        var abc = doc.data();
                        CartProductModel cartProductModel =
                            CartProductModel.toIncreaseorDecrease(doc.data());

                        itemModel.add(
                          CheckOutProductModel(
                            ownerId: cartProductModel.ownerId,
                            name: cartProductModel.name,
                            quantity: cartProductModel.quantity,
                            price: cartProductModel.price,
                            uid: cartProductModel.url[0],
                            isPacked: false,
                          ).toMap(),
                        );
                      }
                      PlaceOrderService().submitOrder(
                        itemModel,
                        widget.totalPrice,
                        "Khalti",
                      );
                      OurToast().showErrorToast("Payment Successful");

                      Get.find<CheckOutScreenController>().changeIndex(2);
                    },
                    onFailure: (fa) {
                      OurToast().showErrorToast("Payment Failed");
                    },
                    onCancel: () {
                      OurToast().showErrorToast("Payment Cancelled");
                    },
                  );
                } else {
                  print("Inside E-sewa");
                  try {
                    EsewaFlutterSdk.initPayment(
                      esewaConfig: EsewaConfig(
                        environment: Environment.test,
                        clientId:
                            "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
                        secretId: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
                      ),
                      esewaPayment: EsewaPayment(
                        productId: "1d71jd81",
                        productName: "Product One",
                        productPrice: widget.totalPrice.toString(),
                        callbackUrl: "www.test-url.com",
                      ),
                      onPaymentSuccess: (EsewaPaymentSuccessResult data) async {
                        debugPrint(":::SUCCESS::: => $data");
                        print("Cash On Delivery");
                        List<Map<String, dynamic>> itemModel = [];
                        var userData = await FirebaseFirestore.instance
                            .collection("Users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get();
                        // FirebaseUserModel firebaseUserModel =FirebaseUser11Model.fromMap(userData);
                        var collection = await FirebaseFirestore.instance
                            .collection("Carts")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("Products")
                            .get();
                        for (var doc in collection.docs) {
                          var abc = doc.data();
                          CartProductModel cartProductModel =
                              CartProductModel.toIncreaseorDecrease(doc.data());

                          itemModel.add(
                            CheckOutProductModel(
                              ownerId: cartProductModel.ownerId,
                              name: cartProductModel.name,
                              quantity: cartProductModel.quantity,
                              price: cartProductModel.price,
                              uid: cartProductModel.url[0],
                              isPacked: false,
                            ).toMap(),
                          );
                        }
                        PlaceOrderService().submitOrder(
                          itemModel,
                          widget.totalPrice,
                          "E-sewa",
                        );

                        OurToast().showErrorToast("Payment Successful");

                        Get.find<CheckOutScreenController>().changeIndex(2);
                      },
                      onPaymentFailure: (data) {
                        debugPrint(":::FAILURE::: => $data");
                        OurToast().showErrorToast("Payment Failed");
                      },
                      onPaymentCancellation: (data) {
                        debugPrint(":::CANCELLATION::: => $data");
                        OurToast().showErrorToast("Payment Cancelled");
                      },
                    );
                  } on Exception catch (e) {
                    debugPrint("EXCEPTION : ${e.toString()}");
                    OurToast().showErrorToast(e.toString());
                  }
                  // ESewaConfiguration _configuration = ESewaConfiguration(
                  //     clientID:
                  //         "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
                  //     secretKey: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
                  //     environment:
                  //         ESewaConfiguration.ENVIRONMENT_TEST //ENVIRONMENT_LIVE
                  //     );
                  // ESewaPnp _eSewaPnp = ESewaPnp(configuration: _configuration);

                  // ESewaPayment _payment = ESewaPayment(
                  //     amount: widget.totalPrice,
                  //     productName: 'Samagri-User TrackingID -$uid',
                  //     productID: uid,
                  //     callBackURL: "http://example.com");
                  // try {
                  //   final _res = await _eSewaPnp.initPayment(payment: _payment);
                  //   print(_res.date);
                  //   print("Utsav Shrestha");
                  //   print(_res.message);
                  // } on ESewaPaymentException catch (e) {
                  //   OurToast().showErrorToast(e.message!);
                  // }

                  print("Esewa");
                }
              }
            },
            borderRadiusAll: ScreenUtil().setSp(10),
            elevation: 0,
            backgroundColor: darklogoColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Place Order: ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(17.5),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "Rs. ${widget.totalPrice.toString()}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(17.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // FxText.bodyMedium(
                //   'Place Order',
                //   fontWeight: 600,
                //   color: theme.colorScheme.onPrimary,
                // ),
                // FxText.bodyMedium(
                //   '\$ 251.55',
                //   fontWeight: 700,
                //   color: theme.colorScheme.onPrimary,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
