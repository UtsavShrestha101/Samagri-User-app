import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/models/delivery_address_model.dart';
import 'package:myapp/screens/dashboard_screen/shopping_map_screen.dart';
import 'package:myapp/widget/our_delivery_address_tile.dart';
import 'package:myapp/widget/our_elevated_button.dart';
import 'package:myapp/widget/our_shimeer_text.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:page_transition/page_transition.dart';

import '../../controller/delivery_time_controller.dart';
import '../../controller/login_controller.dart';
import '../../services/current_location/get_current_location.dart';
import '../../utils/color.dart';
import '../../utils/utils.dart';
import '../../widget/our_delivery_address_row.dart';
import '../../widget/our_spinner.dart';

class ShopAddressChoosingScreen extends StatefulWidget {
  const ShopAddressChoosingScreen({Key? key}) : super(key: key);

  @override
  State<ShopAddressChoosingScreen> createState() =>
      _ShopAddressChoosingScreenState();
}

class _ShopAddressChoosingScreenState extends State<ShopAddressChoosingScreen> {
  Position? position;

  final fromEventController = TextEditingController();
  final totimecontroller = TextEditingController();
  String day = "";
  String time = "";
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
                                });
                              }
                              // print(DateTime.now().difference(date).inHours);
                            },
                            child: Row(
                              children: [
                                Radio(
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
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Radio(
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
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Radio(
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
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Radio(
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
    return Obx(() => ModalProgressHUD(
        inAsyncCall: Get.find<LoginController>().processing.value,
        progressIndicator: OurSpinner(),
        child: Scaffold(
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(10),
                vertical: ScreenUtil().setSp(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          MdiIcons.chevronLeft,
                          size: ScreenUtil().setSp(35),
                          color: darklogoColor,
                        ),
                      ),
                      Expanded(
                        child: OurShimmerText(
                          title: "Choose delivery address",
                        ),
                      ),
                    ],
                  ),
                  OurSizedBox(),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("Location")
                          .orderBy("timestamp", descending: true)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: OurSpinner(),
                          );
                        } else if (snapshot.hasData) {
                          if (snapshot.data!.docs.length > 0) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DeliveryLocation deliveryLocation =
                                    DeliveryLocation.fromJson(
                                        snapshot.data!.docs[index]);
                                return OurDeliveryAddressColumn(
                                  deliveryLocation: deliveryLocation,
                                  function: () {
                                    openBottomSheel(context);
                                  },
                                );
                              },
                            );
                          } else {
                            return Lottie.asset(
                              "assets/animations/location_animation.json",
                              height: ScreenUtil().setSp(250),
                              width: ScreenUtil().setSp(250),
                            );
                          }
                        }
                        return Center(
                          child: OurSpinner(),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(10),
              vertical: ScreenUtil().setSp(10),
            ),
            child: SizedBox(
              height: ScreenUtil().setSp(40),
              child: OurElevatedButton(
                title: "Add new delivery address",
                function: () async {
                  Get.find<LoginController>().toggle(true);
                  position = await GetCurrentLocation().getCurrentLocation();
                  // var placeMarks = await placemarkFromCoordinates(
                  //   position!.latitude,
                  //   position!.longitude,
                  // );
                  Get.find<LoginController>().toggle(false);
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
                        // context: context,
                        addressPlaceHolder: "Loading",
                        addressTitle: "Address",
                        apiKey: "AIzaSyDnx52eVYK2uBy6dvRO8skJyTctk_4K73s",
                        appBarTitle: "Select delivery address",
                        confirmButtonColor: logoColor,
                        confirmButtonText: "Done",
                        confirmButtonTextColor: Colors.white,
                        country: "NP",
                        language: "en",
                        searchHint: "Search",
                        initialLocation: LatLng(
                          position!.latitude,
                          position!.longitude,
                        ),
                      ),
                      type: PageTransitionType.leftToRight,
                    ),
                  );
                },
              ),
            ),
          ),
        )));
  }
}
