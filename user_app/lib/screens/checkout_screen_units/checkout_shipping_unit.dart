import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_flutter_toast.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:page_transition/page_transition.dart';

import '../../controller/check_out_screen_controller.dart';
import '../../controller/delivery_time_controller.dart';
import '../../controller/login_controller.dart';
import '../../models/delivery_address_model.dart';
import '../../services/current_location/get_current_location.dart';
import '../../utils/utils.dart';
import '../../widget/our_delivery_address_row.dart';
import '../../widget/our_spinner.dart';
import '../dashboard_screen/shopping_map_screen.dart';

class CheckOutShipmentUnit extends StatefulWidget {
  const CheckOutShipmentUnit({Key? key}) : super(key: key);

  @override
  State<CheckOutShipmentUnit> createState() => _CheckOutShipmentUnitState();
}

class _CheckOutShipmentUnitState extends State<CheckOutShipmentUnit> {
  String day = "";
  String time = "";
  final fromEventController = TextEditingController();
  final totimecontroller = TextEditingController();
  void openBottomSheel(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Obx(
          () => Container(
            height: MediaQuery.of(context).size.height * 0.65,
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                  appBar: AppBar(
                    leading: Container(),
                    elevation: 0,
                    // leading: Container(),
                    backgroundColor: Colors.transparent,
                    // centerTitle: true,
                    title: Text(
                      "Selects delivery slot",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(20.5),
                        fontWeight: FontWeight.w600,
                        color: logoColor,
                      ),
                    ),
                    actions: [
                      Container(
                        padding: EdgeInsets.only(
                          right: ScreenUtil().setSp(20),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.cancel,
                            color: logoColor,
                            size: ScreenUtil().setSp(25),
                          ),
                        ),
                      )
                    ],
                    bottom: TabBar(
                      indicatorColor: darklogoColor,
                      tabs: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: ScreenUtil().setSp(10),
                          ),
                          child: Text(
                            Utils().customDate(
                              DateTime.now(),
                            ),
                            style: TextStyle(
                              color: logoColor,
                              fontSize: ScreenUtil().setSp(
                                15,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: ScreenUtil().setSp(10),
                          ),
                          child: Text(
                            Utils().customDate(
                              DateTime.now().add(
                                Duration(days: 1),
                              ),
                            ),
                            style: TextStyle(
                              color: logoColor,
                              fontSize: ScreenUtil().setSp(
                                15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setSp(10),
                        vertical: ScreenUtil().setSp(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FxText.b2(
                            "Delivery time must be atleast 120 min after present time.",
                            decoration: TextDecoration.underline,
                            fontSize: ScreenUtil().setSp(12.5),
                          ),
                          Divider(
                            color: darklogoColor,
                          ),
                          InkWell(
                            onTap: () {
                              DateTime date = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                8,
                              );
                              print(date.difference(DateTime.now()).inHours);
                              if (date.difference(DateTime.now()).inHours >=
                                  2) {
                                Get.find<DeliveryTimeController>()
                                    .change("8 am to 11 am");
                                setState(() {
                                  day = Utils().customDate(
                                    DateTime.now(),
                                  );
                                  time = Get.find<DeliveryTimeController>()
                                      .time
                                      .value;
                                  totimecontroller.text = "${Utils().customDate(
                                    DateTime.now(),
                                  )} ${Get.find<DeliveryTimeController>().time.value}";
                                  Get.find<DeliveryTimeController>()
                                      .changeTime("$day, $time");
                                  Navigator.pop(context);
                                });
                              } else {
                                OurToast().showErrorToast(
                                  "Delivery time must be atleast 120 min after present time.",
                                );
                              }
                              // print(DateTime.now().difference(date).inHours);
                            },
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: darklogoColor,
                                  value: Get.find<DeliveryTimeController>()
                                      .time
                                      .value,
                                  groupValue: "8 am to 11 am",
                                  onChanged: (String? value) {},
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "8 am to 11 am",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17.5),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          OurSizedBox(),
                          InkWell(
                            onTap: () {
                              DateTime date = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                11,
                              );
                              if (date.difference(DateTime.now()).inHours > 2) {
                                Get.find<DeliveryTimeController>()
                                    .change("11 am to 2 pm");
                                setState(() {
                                  day = Utils().customDate(
                                    DateTime.now(),
                                  );
                                  time = Get.find<DeliveryTimeController>()
                                      .time
                                      .value;
                                  totimecontroller.text = "${Utils().customDate(
                                    DateTime.now(),
                                  )} ${Get.find<DeliveryTimeController>().time.value}";
                                  Get.find<DeliveryTimeController>()
                                      .changeTime("$day, $time");
                                  Navigator.pop(context);
                                });
                              } else {
                                OurToast().showErrorToast(
                                  "Delivery time must be atleast 120 min after present time.",
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: darklogoColor,
                                  value: Get.find<DeliveryTimeController>()
                                      .time
                                      .value,
                                  groupValue: "11 am to 2 pm",
                                  onChanged: (String? value) {},
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "11 am to 2 pm",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17.5),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          OurSizedBox(),
                          InkWell(
                            onTap: () {
                              DateTime date = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                14,
                              );
                              if (date.difference(DateTime.now()).inHours > 2) {
                                Get.find<DeliveryTimeController>()
                                    .change("2 pm to 5 pm");
                                setState(() {
                                  day = Utils().customDate(
                                    DateTime.now(),
                                  );
                                  time = Get.find<DeliveryTimeController>()
                                      .time
                                      .value;
                                  totimecontroller.text = "${Utils().customDate(
                                    DateTime.now(),
                                  )} ${Get.find<DeliveryTimeController>().time.value}";
                                  Get.find<DeliveryTimeController>()
                                      .changeTime("$day, $time");
                                  Navigator.pop(context);
                                });
                              } else {
                                OurToast().showErrorToast(
                                  "Delivery time must be atleast 120 min after present time.",
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: darklogoColor,
                                  value: Get.find<DeliveryTimeController>()
                                      .time
                                      .value,
                                  groupValue: "2 pm to 5 pm",
                                  onChanged: (String? value) {},
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "2 pm to 5 pm",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17.5),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          OurSizedBox(),
                          InkWell(
                            onTap: () {
                              DateTime date = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                17,
                              );
                              // print(DateTime.now().hour);
                              print(date.difference(DateTime.now()).inDays);
                              if (date.difference(DateTime.now()).inHours > 2) {
                                print("Hello World");
                                Get.find<DeliveryTimeController>()
                                    .change("5 pm to 8 pm");
                                setState(() {
                                  day = Utils().customDate(
                                    DateTime.now(),
                                  );
                                  time = Get.find<DeliveryTimeController>()
                                      .time
                                      .value;
                                  totimecontroller.text = "${Utils().customDate(
                                    DateTime.now(),
                                  )} ${Get.find<DeliveryTimeController>().time.value}";
                                  Get.find<DeliveryTimeController>()
                                      .changeTime("$day, $time");
                                  Navigator.pop(context);
                                });
                              } else {
                                OurToast().showErrorToast(
                                  "Delivery time must be atleast 120 min after present time.",
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: darklogoColor,
                                  value: Get.find<DeliveryTimeController>()
                                      .time
                                      .value,
                                  groupValue: "5 pm to 8 pm",
                                  onChanged: (String? value) {},
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "5 pm to 8 pm",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17.5),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setSp(10),
                        vertical: ScreenUtil().setSp(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FxText.b2(
                            "Delivery time must be atleast 120 min after present time.",
                            decoration: TextDecoration.underline,
                            fontSize: ScreenUtil().setSp(12.5),
                          ),
                          Divider(
                            color: logoColor,
                          ),
                          InkWell(
                            onTap: () {
                              DateTime date = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                8,
                              );

                              if (date.difference(DateTime.now()).inDays >= 0) {
                                Get.find<DeliveryTimeController>()
                                    .change("8 am to 11 am tomorrow");
                                setState(() {
                                  day = Utils().customDate(
                                    DateTime.now().add(
                                      Duration(days: 1),
                                    ),
                                  );
                                  time = Get.find<DeliveryTimeController>()
                                      .time
                                      .value;
                                  Get.find<DeliveryTimeController>()
                                      .changeTime("$day, $time");
                                  Navigator.pop(context);

                                  totimecontroller.text = "${Utils().customDate(
                                    DateTime.now().add(
                                      Duration(days: 1),
                                    ),
                                  )} ${Get.find<DeliveryTimeController>().time.value}";
                                });
                              } else {
                                if (date.difference(DateTime.now()).inHours >=
                                    2) {
                                  Get.find<DeliveryTimeController>()
                                      .change("8 am to 11 am tomorrow");
                                  setState(() {
                                    totimecontroller.text =
                                        Get.find<DeliveryTimeController>()
                                            .time
                                            .value;
                                  });
                                }
                              }
                              // print(DateTime.now().difference(date).inHours);
                            },
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: darklogoColor,
                                  value: Get.find<DeliveryTimeController>()
                                      .time
                                      .value,
                                  groupValue: "8 am to 11 am tomorrow",
                                  onChanged: (String? value) {},
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "8 am to 11 am",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17.5),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          OurSizedBox(),
                          InkWell(
                            onTap: () {
                              DateTime date = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                11,
                              );
                              if (date.difference(DateTime.now()).inDays >= 0) {
                                Get.find<DeliveryTimeController>()
                                    .change("11 am to 2 pm tomorrow");
                                setState(() {
                                  day = Utils().customDate(
                                    DateTime.now().add(
                                      Duration(days: 1),
                                    ),
                                  );
                                  time = Get.find<DeliveryTimeController>()
                                      .time
                                      .value;
                                  Get.find<DeliveryTimeController>()
                                      .changeTime("$day, $time");
                                  Navigator.pop(context);

                                  totimecontroller.text = "${Utils().customDate(
                                    DateTime.now().add(
                                      Duration(days: 1),
                                    ),
                                  )} ${Get.find<DeliveryTimeController>().time.value}";
                                });
                              } else {
                                if (date.difference(DateTime.now()).inHours >
                                    2) {
                                  Get.find<DeliveryTimeController>()
                                      .change("11 am to 2 pm tomorrow");
                                  setState(() {
                                    totimecontroller.text =
                                        Get.find<DeliveryTimeController>()
                                            .time
                                            .value;
                                  });
                                }
                              }
                            },
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: darklogoColor,
                                  value: Get.find<DeliveryTimeController>()
                                      .time
                                      .value,
                                  groupValue: "11 am to 2 pm tomorrow",
                                  onChanged: (String? value) {},
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "11 am to 2 pm",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17.5),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          OurSizedBox(),
                          InkWell(
                            onTap: () {
                              DateTime date = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                14,
                              );
                              if (date.difference(DateTime.now()).inDays >= 0) {
                                Get.find<DeliveryTimeController>()
                                    .change("2 pm to 5 pm tomorrow");
                                setState(() {
                                  day = Utils().customDate(
                                    DateTime.now().add(
                                      Duration(days: 1),
                                    ),
                                  );
                                  time = Get.find<DeliveryTimeController>()
                                      .time
                                      .value;
                                  Get.find<DeliveryTimeController>()
                                      .changeTime("$day, $time");
                                  Navigator.pop(context);

                                  totimecontroller.text = "${Utils().customDate(
                                    DateTime.now().add(
                                      Duration(days: 1),
                                    ),
                                  )} ${Get.find<DeliveryTimeController>().time.value}";
                                });
                              } else {
                                if (date.difference(DateTime.now()).inHours >
                                    2) {
                                  Get.find<DeliveryTimeController>()
                                      .change("2 pm to 5 pm tomorrow");
                                  setState(() {
                                    totimecontroller.text =
                                        Get.find<DeliveryTimeController>()
                                            .time
                                            .value;
                                  });
                                }
                              }
                            },
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: darklogoColor,
                                  value: Get.find<DeliveryTimeController>()
                                      .time
                                      .value,
                                  groupValue: "2 pm to 5 pm tomorrow",
                                  onChanged: (String? value) {},
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "2 pm to 5 pm",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17.5),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          OurSizedBox(),
                          InkWell(
                            onTap: () {
                              DateTime date = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                17,
                              );
                              // print(DateTime.now().hour);
                              print(date.difference(DateTime.now()).inDays);

                              if (date.difference(DateTime.now()).inDays >= 0) {
                                Get.find<DeliveryTimeController>()
                                    .change("5 pm to 8 pm tomorrow");
                                setState(() {
                                  day = Utils().customDate(
                                    DateTime.now().add(
                                      Duration(days: 1),
                                    ),
                                  );
                                  time = Get.find<DeliveryTimeController>()
                                      .time
                                      .value;
                                  Get.find<DeliveryTimeController>()
                                      .changeTime("$day, $time");
                                  Navigator.pop(context);
                                  totimecontroller.text = "${Utils().customDate(
                                    DateTime.now().add(
                                      Duration(days: 1),
                                    ),
                                  )} ${Get.find<DeliveryTimeController>().time.value}";
                                });
                              } else {
                                if (date.difference(DateTime.now()).inHours >
                                    2) {
                                  print("Hello World");
                                  Get.find<DeliveryTimeController>()
                                      .change("5 pm to 8 pm tomorrow");
                                  setState(() {
                                    totimecontroller.text =
                                        Get.find<DeliveryTimeController>()
                                            .time
                                            .value;
                                  });
                                }
                              }
                            },
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: darklogoColor,
                                  value: Get.find<DeliveryTimeController>()
                                      .time
                                      .value,
                                  groupValue: "5 pm to 8 pm tomorrow",
                                  onChanged: (String? value) {},
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "5 pm to 8 pm",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17.5),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
            ),
          ),
        );
      },
    );
  }

  DateTime fromdate = DateTime.now().add(
    Duration(hours: 1),
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OurSizedBox(),
        Text(
          "Select delivery address:",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(17.5),
            color: darklogoColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        OurSizedBox(),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("Location")
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: OurSpinner(),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.docs.length > 0) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DeliveryLocation deliveryLocation =
                        DeliveryLocation.fromJson(snapshot.data!.docs[index]);

                    return Obx(
                      () => FxContainer.bordered(
                        color: Get.find<CheckOutScreenController>()
                                    .addressIndex
                                    .value ==
                                index
                            ? logoColor.withOpacity(0.2)
                            : Colors.transparent,
                        onTap: () {
                          print(deliveryLocation.toJson());
                          Get.find<CheckOutScreenController>()
                              .changeAddressIndex(index);
                          Get.find<CheckOutScreenController>().changeAddress(
                              deliveryLocation.fullAddress!.trim(),
                              deliveryLocation.latitude!,
                              deliveryLocation.longitude!);
                          print(index);
                        },
                        border: Border.all(
                          color: Get.find<CheckOutScreenController>()
                                      .addressIndex
                                      .value ==
                                  index
                              ? darklogoColor
                              : logoColor,
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(2.5),
                          vertical: ScreenUtil().setSp(2.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              deliveryLocation.fullAddress!.trim(),
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(14.5),
                                color: darklogoColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Get.find<CheckOutScreenController>()
                                        .addressIndex
                                        .value ==
                                    index
                                ? Container(
                                    margin: EdgeInsets.only(
                                      top: ScreenUtil().setSp(10),
                                    ),
                                    padding: EdgeInsets.all(
                                      ScreenUtil().setSp(
                                        2.5,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: darklogoColor,
                                        ),
                                        color: darklogoColor),
                                    child: Icon(
                                      Icons.check,
                                      size: ScreenUtil().setSp(20),
                                      color: Colors.white,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OurSizedBox(),
                      Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.contain,
                        height: ScreenUtil().setSp(100),
                        width: ScreenUtil().setSp(100),
                      ),
                      OurSizedBox(),
                      // Text(
                      //   "We're sorry",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w400,
                      //     color: logoColor,
                      //     fontSize: ScreenUtil().setSp(17.5),
                      //   ),
                      // ),
                      // OurSizedBox(),
                      Text(
                        "Please add shipping address.",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                      OurSizedBox(),
                    ],
                  ),
                );
              }
            }
            return Center(
              child: OurSpinner(),
            );
          },
        ),
        OurSizedBox(),
        Row(
          children: [
            Text(
              "Schedule time:",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(17.5),
                color: darklogoColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                openBottomSheel(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(10),
                  vertical: ScreenUtil().setSp(5),
                ),
                // height: ScreenUtil().setSp(40),
                decoration: BoxDecoration(
                  color: darklogoColor,
                  borderRadius: BorderRadius.circular(
                    ScreenUtil().setSp(
                      10,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Choose time",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(17.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Obx(
          () => Text(
            "${Get.find<DeliveryTimeController>().shippingTime}",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(15),
              color: darklogoColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        OurSizedBox(),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  // Get.find<LoginController>().toggle(true);
                  Position? position =
                      await GetCurrentLocation().getCurrentLocation();
                  // Get.find<LoginController>().toggle(false);

                  Navigator.push(
                    context,
                    PageTransition(
                      child: ShopMapScreen(
                        pinWidget: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: ScreenUtil().setSp(50),
                        ),
                        pinColor: Colors.blue,
                        addressPlaceHolder: "Loading",
                        addressTitle: "Address",
                        apiKey: "AIzaSyBlMkiLJ-G7YNmFabacXbMwfI2dectJSfs",
                        appBarTitle: "Select delivery address",
                        confirmButtonColor: logoColor,
                        confirmButtonText: "Done",
                        confirmButtonTextColor: Colors.white,
                        country: "NP",
                        language: "en",
                        searchHint: "Search",
                        initialLocation: LatLng(
                          position!.latitude,
                          position.longitude,
                        ),
                      ),
                      type: PageTransitionType.leftToRight,
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setSp(4.5),
                  ),
                  height: ScreenUtil().setSp(40),
                  decoration: BoxDecoration(
                    color: logoColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(
                      ScreenUtil().setSp(
                        10,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: darklogoColor,
                          size: ScreenUtil().setSp(
                            25,
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setSp(5),
                        ),
                        Text(
                          "Shipment Address",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              16,
                            ),
                            fontWeight: FontWeight.w500,
                            color: darklogoColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (Get.find<DeliveryTimeController>()
                      .shippingTime
                      .trim()
                      .isNotEmpty) {
                    if (Get.find<CheckOutScreenController>().addressIndex !=
                        1000999) {
                      Get.find<CheckOutScreenController>().changeIndex(1);
                    } else {
                      OurToast()
                          .showErrorToast("Please select delivery address");
                    }
                  } else {
                    OurToast().showErrorToast("Please select schedule time");
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setSp(4.5),
                  ),
                  height: ScreenUtil().setSp(40),
                  decoration: BoxDecoration(
                    color: darklogoColor,
                    borderRadius: BorderRadius.circular(
                      ScreenUtil().setSp(
                        10,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Proceed to payment",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(
                          16,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
