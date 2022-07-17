import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker_flutter/google_map_location_picker_flutter.dart';
import 'package:google_maps_pick_place/google_maps_pick_place.dart';
import 'package:myapp/screens/dashboard_screen/shopping_address_choosing_screen.dart';
import 'package:myapp/screens/dashboard_screen/shopping_cart_screen.dart';
import 'package:myapp/screens/dashboard_screen/shopping_delivery_address_screen.dart';
import 'package:myapp/screens/dashboard_screen/shopping_map_screen.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_cart_item_widget.dart';
import 'package:myapp/widget/our_elevated_button.dart';
import 'package:myapp/widget/our_shimeer_text.dart';
import 'package:myapp/widget/our_spinner.dart';
import 'package:page_transition/page_transition.dart';

import '../../models/cart_product_model.dart';
import '../../models/firebase_user_model.dart';
import '../../services/current_location/get_current_location.dart';
import '../../services/firestore_service/product_detail.dart';
import '../../widget/our_sized_box.dart';

class ShoppingMyCartScreen extends StatefulWidget {
  const ShoppingMyCartScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingMyCartScreen> createState() => _ShoppingMyCartScreenState();
}

class _ShoppingMyCartScreenState extends State<ShoppingMyCartScreen> {
  Position? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(10),
            vertical: ScreenUtil().setSp(10),
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.center,
                child: OurShimmerText(title: "My Cart"),
              ),
              OurSizedBox(),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Carts")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("Products")
                      .orderBy(
                        "addedOn",
                        descending: true,
                      )
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: const OurSpinner(),
                      );
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.docs.length > 0) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  CartProductModel cartProductModel =
                                      CartProductModel.fromMap(
                                          snapshot.data!.docs[index]);
                                  return OurCartItemWidget(
                                      cartProductModel: cartProductModel);
                                },
                              ),
                              StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection("Users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.exists) {
                                      FirebaseUserModel firebaseUserModel =
                                          FirebaseUserModel.fromMap(
                                              snapshot.data!.data()!);
                                      return Container(
                                        padding: FxSpacing.all(20),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                FxText.sh1(
                                                  "Subtotal",
                                                  fontWeight: 600,
                                                ),
                                                FxText.sh1(
                                                  "Rs.  ${firebaseUserModel.currentCartPrice}",
                                                  fontWeight: 600,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  FxText.sh1(
                                                    "Delivery cost",
                                                    fontWeight: 600,
                                                  ),
                                                  FxText.sh1(
                                                    "Rs.  60",
                                                    fontWeight: 600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  FxText.sh1("Total",
                                                      fontWeight: 700),
                                                  FxText.sh1(
                                                      "Rs.  ${firebaseUserModel.currentCartPrice + 60}",
                                                      fontWeight: 800),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                  return Text("");
                                },
                              ),
                              OurElevatedButton(
                                title: "CHECKOUT",
                                function: () async {
                                  print("CheckOut");
                                  // position = await GetCurrentLocation()
                                  //     .getCurrentLocation();
                                  // var placeMarks =
                                  //     await placemarkFromCoordinates(
                                  //   position!.latitude,
                                  //   position!.longitude,
                                  // );

                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context) {
                                  //   return ShopMapScreen(
                                  //     pinWidget: Icon(
                                  //       Icons.location_pin,
                                  //       color: Colors.red,
                                  //       size: 55,
                                  //     ),
                                  //     pinColor: Colors.blue,
                                  //     // context: context,
                                  //     addressPlaceHolder: "Loading",
                                  //     addressTitle: "Address",
                                  //     apiKey:
                                  //         "AIzaSyCj5y6leoSyCt1eZaqaWyrsBhToOiLuGSo",
                                  //     appBarTitle: "Select delivery address",
                                  //     confirmButtonColor: logoColor,
                                  //     confirmButtonText: "Done",
                                  //     confirmButtonTextColor: Colors.white,
                                  //     country: "NP",
                                  //     language: "en",
                                  //     searchHint: "Search",
                                  //     initialLocation: LatLng(
                                  //       position!.latitude,
                                  //       position!.longitude,
                                  //     ),
                                  //   );
                                  // }));

                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.leftToRight,
                                      child: ShopAddressChoosingScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Image.asset(
                            "assets/images/empty.png",
                            height: ScreenUtil().setSp(200),
                            width: ScreenUtil().setSp(200),
                          ),
                        );
                      }
                    }
                    return const Center(
                      child: OurSpinner(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
