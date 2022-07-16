import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/controller/quantity_controller.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/models/review_model.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_sized_box.dart';
import '../../../utils/generator.dart';
import '../../controller/dashboard_controller.dart';
import '../../controller/login_controller.dart';
import '../../models/firebase_user_model.dart';
import '../../services/firestore_service/product_detail.dart';
import '../../services/firestore_service/userprofile_detail.dart';
import '../../widget/our_elevated_button.dart';
import '../../widget/our_flutter_toast.dart';
import '../../widget/our_shimeer_text.dart';
import '../../widget/our_spinner.dart';
import '../../widget/our_text_field.dart';
import 'shopping_cart_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class ShoppingProductScreen extends StatefulWidget {
  final String heroTag;
  final ProductModel productModel;
  const ShoppingProductScreen({
    Key? key,
    this.heroTag = "heroTag",
    required this.productModel,
    // this.image = './assets/images/apps/shopping/product/product-3.jpg'
  }) : super(key: key);

  @override
  _ShoppingProductScreenState createState() => _ShoppingProductScreenState();
}

class _ShoppingProductScreenState extends State<ShoppingProductScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _review_Controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<QuantityController>().changeQuantity(1);
  }

  void GiveRatingSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xffe1ebfa),
            height: MediaQuery.of(context).size.height * 0.75,
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(20),
              vertical: ScreenUtil().setSp(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const OurShimmerText(
                  title: "Reviews",
                ),
                const OurSizedBox(),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Products")
                        .doc(widget.productModel.uid)
                        .collection("Reviews")
                        .orderBy(
                          "timestamp",
                          descending: true,
                        )
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.length > 0) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                ReviewModel reviewModel = ReviewModel.fromMap(
                                    snapshot.data!.docs[index]);
                                return InkWell(
                                  onLongPress: () async {
                                    if (reviewModel.senderId ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
                                      await FirebaseFirestore.instance
                                          .collection("Products")
                                          .doc(widget.productModel.uid)
                                          .collection("Reviews")
                                          .doc(reviewModel.uid)
                                          .delete();
                                      OurToast()
                                          .showErrorToast("Review Deleted");
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  reviewModel.senderName,
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(17.5),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const OurSizedBox(),
                                                Text(
                                                  reviewModel.review,
                                                  style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(15),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              timeago.format(
                                                reviewModel.timestamp.toDate(),
                                              ),
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(12.5),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const OurSizedBox(),
                                      const Divider(),
                                      const OurSizedBox(),
                                    ],
                                  ),
                                );
                              });
                        } else {
                          return Center(
                            child: Text(
                              "No Reviews yet",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                                color: logoColor,
                              ),
                            ),
                          );
                        }
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: OurSpinner());
                      }
                      return const OurSpinner();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          icon: Icons.reviews,
                          controller: _review_Controller,
                          validator: (value) {},
                          title: "Give Review",
                          type: TextInputType.name,
                          number: 1,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (_review_Controller.text.trim().isNotEmpty) {
                            Get.find<LoginController>().toggle(true);
                            var data = await FirebaseFirestore.instance
                                .collection("Users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .get();

                            var name = data.data()!["name"];
                            await ProductDetailFirestore().addReview(
                              _review_Controller.text.trim(),
                              widget.productModel.uid,
                              name,
                            );
                            _review_Controller.clear();
                            FocusManager.instance.primaryFocus?.unfocus();
                            Get.find<LoginController>().toggle(false);
                          } else {
                            OurToast().showErrorToast("Review can't be empty");
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: logoColor,
                          size: ScreenUtil().setSp(30),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> _showMyDialog(double rate, bool exists) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: OurShimmerText(
                title: "Give Rating",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingStars(
                    onValueChanged: (value) {
                      setState(() {
                        rate = value;
                      });
                    },
                    value: rate,
                    starBuilder: (index, color) => Icon(
                      Icons.star,
                      color: color,
                      size: ScreenUtil().setSp(25),
                    ),
                    starCount: 5,
                    starSize: ScreenUtil().setSp(20),
                    valueLabelColor: const Color(0xff9b9b9b),
                    valueLabelTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                    valueLabelRadius: ScreenUtil().setSp(20),
                    maxValue: 5,
                    starSpacing: ScreenUtil().setSp(10),
                    maxValueVisibility: true,
                    valueLabelVisibility: true,
                    animationDuration: const Duration(milliseconds: 1000),
                    valueLabelPadding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setSp(5),
                      horizontal: ScreenUtil().setSp(5),
                    ),
                    valueLabelMargin: EdgeInsets.only(
                      right: ScreenUtil().setSp(3),
                    ),
                    starOffColor: const Color(0xffe7e8ea),
                    starColor: Colors.yellow,
                  ),
                ],
              ),
              actions: <Widget>[
                OurElevatedButton(
                    title: "Submit",
                    function: () async {
                      await ProductDetailFirestore()
                          .addRating(widget.productModel, rate);
                      if (!exists) {
                        await ProductDetailFirestore()
                            .updateRatingNo(widget.productModel);
                      }
                      await ProductDetailFirestore()
                          .updateProductRating(widget.productModel);
                      Navigator.pop(context);
                    }),
              ],
            );
          },
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(
        () => ModalProgressHUD(
          inAsyncCall: Get.find<LoginController>().processing.value,
          progressIndicator: OurSpinner(),
          child: Scaffold(
            body: Container(
              // margin: EdgeInsets.symmetric(
              //   horizontal: ScreenUtil().setSp(10),
              //   vertical: ScreenUtil().setSp(10),
              // ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Products")
                    .where("uid", isEqualTo: widget.productModel.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: OurSpinner(),
                    );
                  } else if (snapshot.hasData) {
                    ProductModel productModel =
                        ProductModel.fromMap(snapshot.data!.docs[0]);
                    return Column(
                      children: [
                        // Row(
                        //   children: [
                        //     InkWell(
                        //       onTap: () {
                        //         Navigator.of(context).pop();
                        //       },
                        //       child: Icon(
                        //         MdiIcons.chevronLeft,
                        //         size: ScreenUtil().setSp(35),
                        //         color: darklogoColor,
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Align(
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           productModel.name,
                        //           style: TextStyle(
                        //             color: darklogoColor,
                        //             fontSize: ScreenUtil().setSp(22.5),
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     productModel.favorite.contains(
                        //             FirebaseAuth.instance.currentUser!.uid)
                        //         ? InkWell(
                        //             onTap: () async {
                        //               await UserDetailFirestore()
                        //                   .removeFavorite(widget.productModel);
                        //               print("Favourite Removed");
                        //             },
                        //             child: Icon(
                        //               MdiIcons.heart,
                        //               color: Colors.red,
                        //               size: ScreenUtil().setSp(30),
                        //             ),
                        //           )
                        //         : InkWell(
                        //             onTap: () async {
                        //               await UserDetailFirestore()
                        //                   .addFavorite(widget.productModel);
                        //               print("Favourite Added");
                        //             },
                        //             child: Icon(
                        //               MdiIcons.heartOutline,
                        //               color: darklogoColor,
                        //               size: ScreenUtil().setSp(30),
                        //             ),
                        //           ),
                        //   ],
                        // ),
                        // OurSizedBox(),
                        // OurSizedBox(),
                        // OurSizedBox(),
                        Stack(
                          children: [
                            Hero(
                              tag: widget.heroTag,
                              child: ClipRRect(
                                // borderRadius: BorderRadius.all(
                                //   Radius.circular(
                                //     ScreenUtil().setSp(15),
                                //   ),
                                // ),
                                child: CachedNetworkImage(
                                  // width: MediaQuery.of(context).size.width * 0.65,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,

                                  fit: BoxFit.fill,
                                  imageUrl: widget.productModel.url,
                                  placeholder: (context, url) => Image.asset(
                                    "assets/images/placeholder.png",
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    fit: BoxFit.cover,
                                    // width: ScreenUtil().setSp(150),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: ScreenUtil().setSp(25),
                              left: 0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setSp(2.5),
                                    vertical: ScreenUtil().setSp(2),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setSp(2.5),
                                    vertical: ScreenUtil().setSp(2),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    MdiIcons.chevronLeft,
                                    size: ScreenUtil().setSp(35),
                                    color: darklogoColor,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: ScreenUtil().setSp(25),
                              right: 0,
                              child: Container(
                                // width: ScreenUtil().setSp(fontSize),
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setSp(7.5),
                                  vertical: ScreenUtil().setSp(5),
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setSp(5),
                                  vertical: ScreenUtil().setSp(5),
                                ),

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    ScreenUtil().setSp(35),
                                  ),
                                  // color: Colors.amber,
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                // decoration: BoxDecoration(
                                //     shape: BoxShape.circle),
                                child: Expanded(
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.find<DashboardController>()
                                              .changeIndexs(3);
                                          Navigator.pop(context);
                                          // print("Show cart screen");
                                        },
                                        child: StreamBuilder<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>(
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
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Icon(
                                                MdiIcons.cartOutline,
                                                color: darklogoColor,
                                                size: ScreenUtil().setSp(22.5),
                                              );
                                            } else if (snapshot.hasData) {
                                              if (snapshot.data!.exists) {
                                                FirebaseUserModel
                                                    firebaseUserModel =
                                                    FirebaseUserModel.fromMap(
                                                        snapshot.data!.data()!);
                                                return Badge(
                                                  badgeColor: darklogoColor,
                                                  position:
                                                      BadgePosition.topEnd(),
                                                  badgeContent: Text(
                                                    firebaseUserModel.cartItemNo
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(15),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                  child: Icon(
                                                    MdiIcons.cartOutline,
                                                    color: darklogoColor,
                                                    size:
                                                        ScreenUtil().setSp(25),
                                                  ),
                                                );
                                              } else {
                                                return Icon(
                                                  MdiIcons.cartOutline,
                                                  color: darklogoColor,
                                                  size: ScreenUtil().setSp(25),
                                                );
                                              }
                                            }
                                            return Icon(
                                              MdiIcons.cart,
                                              color: darklogoColor,
                                              size: ScreenUtil().setSp(25),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setSp(20),
                                      ),
                                      productModel.favorite.contains(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          ? InkWell(
                                              onTap: () async {
                                                await UserDetailFirestore()
                                                    .removeFavorite(
                                                        widget.productModel);
                                                print("Favourite Removed");
                                              },
                                              child: Icon(
                                                MdiIcons.heart,
                                                color: Colors.red,
                                                size: ScreenUtil().setSp(30),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () async {
                                                await UserDetailFirestore()
                                                    .addFavorite(
                                                        widget.productModel);
                                                print("Favourite Added");
                                              },
                                              child: Icon(
                                                MdiIcons.heartOutline,
                                                color: darklogoColor,
                                                size: ScreenUtil().setSp(30),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        OurSizedBox(),
                        Center(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                FxText.b2(
                                  productModel.name,
                                  fontWeight: 600,
                                  fontSize: ScreenUtil().setSp(20),
                                ),
                                OurSizedBox(),
                                FxText.h4(
                                  "Rs. ${productModel.price}",
                                  fontWeight: 500,
                                  letterSpacing: 0,
                                  fontSize: ScreenUtil().setSp(18.5),
                                ),
                                OurSizedBox(),
                                FxText.h4(
                                  "${productModel.desc}",
                                  fontWeight: 500,
                                  letterSpacing: 0,
                                  fontSize: ScreenUtil().setSp(18.5),
                                ),
                                OurSizedBox(),
                                GestureDetector(
                                  onTap: () async {
                                    if (productModel.ratingUID.contains(
                                        FirebaseAuth
                                            .instance.currentUser!.uid)) {
                                      var a = await FirebaseFirestore.instance
                                          .collection("Rating")
                                          .doc(productModel.uid)
                                          .collection("Ratings")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .get();

                                      var rate = a.data()!["rating"];
                                      _showMyDialog(rate, true);
                                    } else {
                                      _showMyDialog(0.0, false);
                                    }
                                  },
                                  child: RatingStars(
                                    value: productModel.rating.toDouble(),
                                    starBuilder: (index, color) => Icon(
                                      Icons.star,
                                      color: color,
                                      size: ScreenUtil().setSp(25),
                                    ),
                                    starCount: 5,
                                    starSize: ScreenUtil().setSp(25),
                                    valueLabelColor: const Color(0xff9b9b9b),
                                    valueLabelTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: ScreenUtil().setSp(15),
                                    ),
                                    valueLabelRadius: ScreenUtil().setSp(20),
                                    maxValue: 5,
                                    starSpacing: 1,
                                    maxValueVisibility: true,
                                    valueLabelVisibility: true,
                                    animationDuration:
                                        const Duration(milliseconds: 1000),
                                    valueLabelPadding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setSp(7.5),
                                      horizontal: ScreenUtil().setSp(7.5),
                                    ),
                                    valueLabelMargin: EdgeInsets.only(
                                      right: ScreenUtil().setSp(5),
                                    ),
                                    starOffColor: Colors.white,
                                    starColor: Colors.yellow,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        OurSizedBox(),
                        OurElevatedButton(
                          title: "Give Review",
                          function: () {
                            GiveRatingSheet(context);
                          },
                        ),
                      ],
                    );
                  }
                  return Center(
                    child: OurSpinner(),
                  );
                },
              ),
            ),
            bottomNavigationBar: Container(
              height: ScreenUtil().setSp(40),
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
                vertical: ScreenUtil().setSp(10),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                ScreenUtil().setSp(20),
              )),
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.exists) {
                      FirebaseUserModel firebaseUserModel =
                          FirebaseUserModel.fromMap(snapshot.data!.data()!);
                      if (firebaseUserModel.cartItems
                          .contains(widget.productModel.uid)) {
                        return OurElevatedButton(
                          title: "Remove from cart",
                          function: () async {
                            await ProductDetailFirestore().removeItemFromCart(
                                firebaseUserModel, widget.productModel);
                          },
                        );
                      } else {
                        return Row(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: ScreenUtil().setSp(50),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                        EdgeInsets.zero,
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        logoColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (Get.find<QuantityController>()
                                              .quantity >
                                          1) {
                                        Get.find<QuantityController>()
                                            .changeQuantity(
                                                Get.find<QuantityController>()
                                                        .quantity
                                                        .value -
                                                    1);
                                      }
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      size: ScreenUtil().setSp(25),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setSp(5),
                                ),
                                Obx(
                                  () => Text(
                                    Get.find<QuantityController>()
                                        .quantity
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(20),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setSp(5),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setSp(50),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                        EdgeInsets.zero,
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        logoColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.find<QuantityController>()
                                          .changeQuantity(
                                              Get.find<QuantityController>()
                                                      .quantity
                                                      .value +
                                                  1);
                                    },
                                    child: Icon(
                                      Icons.add,
                                      size: ScreenUtil().setSp(25),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: ScreenUtil().setSp(30),
                            ),
                            Expanded(
                              child: OurElevatedButton(
                                title: "Add to cart",
                                function: () async {
                                  await ProductDetailFirestore().addItemToCart(
                                      firebaseUserModel,
                                      widget.productModel,
                                      Get.find<QuantityController>()
                                          .quantity
                                          .value);
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
