import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/utils/color.dart';
import 'package:page_transition/page_transition.dart';
import '../models/user_model.dart';
import '../screens/dashboard_screen/shopping_product_screen.dart';
import '../screens/dashboard_screen/shopping_shop_profile_screen.dart';
import '../services/firestore_service/userprofile_detail.dart';
import '../services/network_connection/network_connection.dart';
import '../utils/generator.dart';
import 'our_flutter_toast.dart';

class OurSearchProductListTile extends StatefulWidget {
  final ProductModel productModel;
  final BuildContext buildContext;
  const OurSearchProductListTile({
    Key? key,
    required this.buildContext,
    required this.productModel,
  }) : super(key: key);

  @override
  State<OurSearchProductListTile> createState() =>
      _OurSearchProductListTileState();
}

class _OurSearchProductListTileState extends State<OurSearchProductListTile> {
  @override
  Widget build(BuildContext context) {
    String key = Generator.randomString(10);
    return InkWell(
      onTap: () {
        Hive.box<String>("product_history").put(
          widget.productModel.uid,
          widget.productModel.name,
        );
        FocusScope.of(context).unfocus();

        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            reverseTransitionDuration: Duration(seconds: 1),
            pageBuilder: ((context, animation, secondaryAnimation) {
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.0,
                  0.5,
                ),
              );
              return FadeTransition(
                opacity: curvedAnimation,
                child: ShoppingProductScreen(
                  heroTag: key,
                  productModel: widget.productModel,
                ),
              );
            }),
          ),
        );
        FocusScope.of(context).unfocus();
      },
      child: FxContainer(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(4),
          vertical: ScreenUtil().setSp(4),
        ),
        padding: EdgeInsets.all(
          ScreenUtil().setSp(10),
        ),
        child: Row(
          children: <Widget>[
            Hero(
              tag: key,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    ScreenUtil().setSp(8),
                  ),
                ),
                child:

                    // Text("as")
                    // Image.network(
                    //   widget.productModel.url[0],
                    //   height: ScreenUtil().setSp(90),
                    //   width: ScreenUtil().setSp(90),
                    //   // width: double.infinity,
                    //   fit: BoxFit.fill,
                    // ),
                    CachedNetworkImage(
                  height: ScreenUtil().setSp(90),
                  width: ScreenUtil().setSp(90),
                  // width: double.infinity,
                  fit: BoxFit.fill,
                  imageUrl: widget.productModel.url[0],
                  placeholder: (context, url) => Image.asset(
                    "assets/images/placeholder.png",
                    height: ScreenUtil().setSp(90),
                    width: ScreenUtil().setSp(90),
                  ),
                ),
              ),
            ),
            FxSpacing.width(20),
            Expanded(
              child: Container(
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Hero(
                          tag: "NameTag-$key",
                          child: Material(
                            type: MaterialType.transparency,
                            child: FxText.sh1(
                              widget.productModel.name,
                              fontWeight: 600,
                              letterSpacing: 0,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(15),
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        widget.productModel.favorite.contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? Hero(
                                tag: "Liked-$key",
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    onTap: () async {
                                      if (Get.find<CheckConnectivity>()
                                              .isOnline ==
                                          false) {
                                        OurToast().showErrorToast(
                                            "Oops, No internet connection");
                                      } else {
                                        await UserDetailFirestore()
                                            .removeFavorite(
                                                widget.productModel);
                                      }

                                      print("Favourite Removed");
                                    },
                                    child: Icon(
                                      MdiIcons.heart,
                                      color: Colors.red,
                                      size: ScreenUtil().setSp(20),
                                    ),
                                  ),
                                ),
                              )
                            : Hero(
                                tag: "NotLiked-$key",
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    onTap: () async {
                                      if (Get.find<CheckConnectivity>()
                                              .isOnline ==
                                          false) {
                                        OurToast().showErrorToast(
                                            "Oops, No internet connection");
                                      } else {
                                        await UserDetailFirestore()
                                            .addFavorite(widget.productModel);
                                      }

                                      print("Favourite Added");
                                    },
                                    child: Icon(
                                      MdiIcons.heartOutline,
                                      color: Colors.grey.shade400,
                                      size: ScreenUtil().setSp(20),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    Hero(
                      tag: "Rating-$key",
                      child: Material(
                        type: MaterialType.transparency,
                        child: RatingStars(
                          value: double.parse(
                              widget.productModel.rating.toString()),
                          starBuilder: (index, color) => Icon(
                            Icons.star,
                            color: color,
                            size: ScreenUtil().setSp(17),
                          ),
                          starCount: 5,
                          starSize: ScreenUtil().setSp(17),
                          valueLabelColor: const Color(0xff9b9b9b),
                          valueLabelTextStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: ScreenUtil().setSp(12),
                          ),
                          valueLabelRadius: ScreenUtil().setSp(20),
                          maxValue: 5,
                          starSpacing: 1,
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
                          starColor: darklogoColor,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        DocumentSnapshot abc = await FirebaseFirestore.instance
                            .collection("Sellers")
                            .doc(widget.productModel.ownerUid)
                            .get();
                        UserModel userModel = UserModel.fromMap(abc);
                        Navigator.push(
                          context,
                          PageTransition(
                            child: ShoppingShopProfileScreen(
                              userModel: userModel,
                              shopName: widget.productModel.shop_name,
                              shopOwnerUID: widget.productModel.ownerUid,
                            ),
                            type: PageTransitionType.leftToRight,
                          ),
                        );
                        // print("Button Pressed");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    MdiIcons.storeOutline,
                                    color: darklogoColor,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 4),
                                    child: FxText.b2(
                                      widget.productModel.shop_name,
                                      color: darklogoColor,
                                      fontWeight: 500,
                                    ),
                                  )
                                ],
                              ),
                              // Icon(
                              //   MdiIcons.storeOutline,
                              //   color: darklogoColor,
                              //   size: 20,
                              // ),
                              // Container(
                              //   margin: EdgeInsets.only(left: 4),
                              //   child: FxText.b2(
                              //     widget.shopName,
                              //     color: darklogoColor,
                              //     fontWeight: 500,
                              //   ),
                              // )
                            ],
                          ),
                          Hero(
                            tag: "Price-$key",
                            child: Material(
                              type: MaterialType.transparency,
                              child: FxText.b2(
                                "Rs " + widget.productModel.price.toString(),
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                  fontWeight: FontWeight.w400,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
