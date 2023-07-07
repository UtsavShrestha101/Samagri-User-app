import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/screens/dashboard_screen/shopping_address_choosing_screen.dart';
import 'package:myapp/screens/dashboard_screen/shopping_check_account_screen.dart';
import 'package:myapp/screens/dashboard_screen/test_screen.dart';
import 'package:myapp/widget/our_cart_item_widget.dart';
import 'package:myapp/widget/our_elevated_button.dart';
import 'package:myapp/widget/our_shimeer_text.dart';
import 'package:myapp/widget/our_spinner.dart';
import 'package:page_transition/page_transition.dart';
import '../../models/cart_product_model.dart';
import '../../models/firebase_user_model.dart';
import '../../utils/color.dart';
import '../../widget/our_sized_box.dart';

class ShoppingMyCartScreen extends StatefulWidget {
  const ShoppingMyCartScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingMyCartScreen> createState() => _ShoppingMyCartScreenState();
}

class _ShoppingMyCartScreenState extends State<ShoppingMyCartScreen>
    with TickerProviderStateMixin {
  Position? position;
  late AnimationController animationControllerListPage;
  late Animation<double> logoAnimationList;
  late Animation<double> fadeAnimation;
  late AnimationController animationController;

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    animationControllerListPage.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animationControllerListPage = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );

    logoAnimationList = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
        parent: animationControllerListPage,
        curve: Curves.linear,
      ),
    );
    animationControllerListPage.repeat(reverse: true);
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );
    animationController.forward();
  }

  late FirebaseUserModel firebaseUserModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: fadeAnimation,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(10),
              vertical: ScreenUtil().setSp(10),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RotationTransition(
                        turns: logoAnimationList,
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: ScreenUtil().setSp(23.5),
                          width: ScreenUtil().setSp(23.5),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(7.5),
                      ),
                      Text(
                        "My Cart",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(25),
                          color: darklogoColor,
                        ),
                      ),
                    ],
                  ),
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
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<
                                              DocumentSnapshot<
                                                  Map<String, dynamic>>>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.exists) {
                                        firebaseUserModel =
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
                                                padding:
                                                    EdgeInsets.only(top: 12),
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
                                                padding:
                                                    EdgeInsets.only(top: 12),
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
                                    print("CheckOut Utsav 123");
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
                                    //         "AIzaSyDnx52eVYK2uBy6dvRO8skJyTctk_4K73s",
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

                                    // KhaltiPaymentPage();
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.leftToRight,
                                        child: ShoppingCheckOutScreen(
                                          totalPrice: firebaseUserModel
                                                  .currentCartPrice +
                                              60,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.contain,
                                  height: ScreenUtil().setSp(150),
                                  width: ScreenUtil().setSp(150),
                                ),
                                OurSizedBox(),
                                Text(
                                  "We're sorry",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: logoColor,
                                    fontSize: ScreenUtil().setSp(17.5),
                                  ),
                                ),
                                OurSizedBox(),
                                Text(
                                  "No item added to the cart",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: ScreenUtil().setSp(15),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.contain,
                              height: ScreenUtil().setSp(150),
                              width: ScreenUtil().setSp(150),
                            ),
                            OurSizedBox(),
                            Text(
                              "We're sorry",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: logoColor,
                                fontSize: ScreenUtil().setSp(17.5),
                              ),
                            ),
                            OurSizedBox(),
                            Text(
                              "No item added to the cart",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: ScreenUtil().setSp(15),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
