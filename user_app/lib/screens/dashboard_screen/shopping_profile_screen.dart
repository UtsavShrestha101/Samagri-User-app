import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/models/firebase_user_model.dart';
import 'package:myapp/screens/dashboard_screen/shopping_favourite_screen.dart';
import 'package:myapp/screens/dashboard_screen/shopping_map_screen.dart';
import 'package:myapp/services/fetch_product/fetch_product.dart';
import 'package:myapp/services/phone_auth/phone_auth.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_setting_box_tile.dart';
import 'package:myapp/widget/our_setting_tile.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:page_transition/page_transition.dart';

import '../../controller/login_controller.dart';
import '../../services/current_location/get_current_location.dart';
import '../../widget/our_spinner.dart';

class ShoppingProfileScreen extends StatefulWidget {
  @override
  _ShoppingProfileScreenState createState() => _ShoppingProfileScreenState();
}

class _ShoppingProfileScreenState extends State<ShoppingProfileScreen> {
  Position? position;

  @override
  Widget build(BuildContext context) {
    return Obx(() => ModalProgressHUD(
          inAsyncCall: Get.find<LoginController>().processing.value,
          progressIndicator: OurSpinner(),
          child: Scaffold(
              body: SafeArea(
            child: ListView(
              padding: EdgeInsets.all(
                ScreenUtil().setSp(20),
              ),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setSp(16),
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: OurSpinner(),
                        );
                      } else {
                        if (snapshot.hasData) {
                          FirebaseUserModel firebaseUserModel =
                              FirebaseUserModel.fromMap(snapshot.data!.data()!);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FxText.sh1(
                                firebaseUserModel.name,
                                fontWeight: 700,
                                letterSpacing: 0,
                                color: darklogoColor,
                                fontSize: ScreenUtil().setSp(17.5),
                              ),
                              SizedBox(
                                height: ScreenUtil().setSp(5),
                              ),
                              FxText.caption(
                                firebaseUserModel.phone,
                                fontWeight: 500,
                                letterSpacing: 0.3,
                                color: darklogoColor,
                                fontSize: ScreenUtil().setSp(
                                  15,
                                ),
                              ),
                            ],
                          );
                        }
                        return Container();
                      }
                    },
                  ),
                ),
                OurSizedBox(),
                OurSizedBox(),
                OurSizedBox(),
                Row(
                  children: <Widget>[
                    OurSettingBoxTile(
                      title: "Address",
                      iconData: MdiIcons.mapMarkerOutline,
                      function: () async {
                        Get.find<LoginController>().toggle(true);
                        position =
                            await GetCurrentLocation().getCurrentLocation();
                        var placeMarks = await placemarkFromCoordinates(
                          position!.latitude,
                          position!.longitude,
                        );
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
                                position!.longitude,
                              ),
                            ),
                            type: PageTransitionType.leftToRight,
                          ),
                        );
                      },
                    ),
                    FxSpacing.width(10),
                    OurSettingBoxTile(
                        title: "Payment",
                        iconData: MdiIcons.creditCardOutline,
                        function: () {
                          print("Payment");
                        }),
                    FxSpacing.width(10),
                    OurSettingBoxTile(
                        title: "History",
                        iconData: MdiIcons.contentPaste,
                        function: () {
                          print("History");
                        })
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Column(
                    children: <Widget>[
                      OurSettingTile(
                        title: "Favourite",
                        iconData: MdiIcons.heartOutline,
                        function: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRight,
                              child: ShoppingFavouriteScreen(),
                            ),
                          );
                        },
                      ),
                      OurSettingTile(
                        title: "Notifications",
                        iconData: MdiIcons.bellRingOutline,
                        function: () {},
                      ),
                      OurSettingTile(
                        title: "Appearance",
                        iconData: MdiIcons.eyeOutline,
                        function: () {},
                      ),
                      OurSettingTile(
                        title: "Help \& Support",
                        iconData: MdiIcons.faceAgent,
                        function: () {},
                      ),
                      OurSettingTile(
                        title: "Logout",
                        iconData: MdiIcons.logout,
                        function: () async {
                          // await FetchProductFirebase()
                          //     .fetchproductfirebase("Grocery");
                           await PhoneAuth().logout();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
        ));
  }
}
