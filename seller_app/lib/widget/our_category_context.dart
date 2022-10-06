import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:myapp/widget/our_spinner.dart';

import '../screens/dashboard_screen/shopping_product_screen.dart';
import '../services/firestore_service/userprofile_detail.dart';
import '../utils/color.dart';
import '../utils/generator.dart';
import 'our_product_grid_loading_widget.dart';
import 'our_product_grid_tile.dart';

class OurCategoryContext extends StatefulWidget {
  final String category;
  const OurCategoryContext({Key? key, required this.category})
      : super(key: key);

  @override
  State<OurCategoryContext> createState() => _OurCategoryContextState();
}

class _OurCategoryContextState extends State<OurCategoryContext> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OurSizedBox(),
          Text(
            "${widget.category}:",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(22.5),
              color: logoColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const OurSizedBox(),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("All")
                .where(
                  "category",
                  arrayContains: widget.category,
                )
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return OurProductGridLoadingScreen();
              } else if (snapshot.hasData) {
                if (snapshot.data!.docs.length > 0) {
                  // return GridView.builder(
                  //   padding: EdgeInsets.zero,
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemCount: snapshot.data!.docs.length,
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2,
                  //     crossAxisSpacing: ScreenUtil().setSp(5),
                  //     mainAxisSpacing: ScreenUtil().setSp(5),
                  //     childAspectRatio: 0.7,
                  //   ),
                  //   itemBuilder: (context, index) {
                  //     ProductModel productModel =
                  //         ProductModel.fromMap(snapshot.data!.docs[index]);
                  //     return ProductGridTile(
                  //       productModel: productModel,
                  //       rootContext: context,
                  //     );
                  //   },
                  // );
                  return SizedBox(
                    height: ScreenUtil().setSp(255),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          ProductModel productModel =
                              ProductModel.fromMap(snapshot.data!.docs[index]);
                          String key = Generator.randomString(10);
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: Duration(seconds: 1),
                                    reverseTransitionDuration:
                                        Duration(seconds: 1),
                                    pageBuilder: ((context, animation,
                                        secondaryAnimation) {
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
                                          productModel: productModel,
                                          // image: widget.productModel.url,
                                        ),
                                      );
                                    }),
                                  )
                                  // MaterialPageRoute(
                                  // builder: (context) => ShoppingProductScreen(
                                  //   heroTag: key,
                                  //   productModel: widget.productModel,
                                  //   // image: widget.productModel.url,
                                  // ),
                                  // ),
                                  );
                            },
                            child: FxContainer.bordered(
                              width: MediaQuery.of(context).size.width * 0.475,
                              color: Colors.transparent,
                              margin: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setSp(2),
                              ),
                              padding: EdgeInsets.only(
                                left: ScreenUtil().setSp(5),
                                right: ScreenUtil().setSp(5),
                                bottom: ScreenUtil().setSp(2.5),
                                top: ScreenUtil().setSp(5),
                              ),
                              child: Column(
                                children: [
                                  Stack(
                                    children: <Widget>[
                                      Hero(
                                        tag: key,
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                ScreenUtil().setSp(10),
                                              ),
                                            ),
                                            child: CachedNetworkImage(
                                              height: ScreenUtil().setSp(160),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                              imageUrl: productModel.url[0],
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                "assets/images/placeholder.png",
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                // width: ScreenUtil().setSp(150),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: ScreenUtil().setSp(7.5),
                                        top: ScreenUtil().setSp(7.5),
                                        child: productModel.favorite.contains(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            ? Hero(
                                                tag: "Liked-$key",
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await UserDetailFirestore()
                                                          .removeFavorite(
                                                              productModel);
                                                      print(
                                                          "Favourite Removed");
                                                    },
                                                    child: Icon(
                                                      MdiIcons.heart,
                                                      color: Colors.red,
                                                      size: ScreenUtil()
                                                          .setSp(20),
                                                    ),
                                                  ),
                                                ))
                                            : Hero(
                                                tag: "NotLiked-$key",
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      print("HELLO WORLD");

                                                      await UserDetailFirestore()
                                                          .addFavorite(
                                                              productModel);
                                                      print("Favourite Added");
                                                    },
                                                    child: Icon(
                                                      MdiIcons.heartOutline,
                                                      color:
                                                          Colors.grey.shade400,
                                                      size: ScreenUtil()
                                                          .setSp(20),
                                                    ),
                                                  ),
                                                )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setSp(2.5),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    // padding: EdgeInsets.only(
                                    //   top: ScreenUtil().setSp(6),
                                    // ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Hero(
                                          tag: "NameTag-$key",
                                          child: Material(
                                            type: MaterialType.transparency,
                                            child: FxText.b1(
                                              productModel.name,
                                              fontWeight: 700,
                                              letterSpacing: 0,
                                              color: logoColor,
                                              fontSize:
                                                  ScreenUtil().setSp(17.5),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setSp(2.5),
                                        ),

                                        SizedBox(
                                          height: ScreenUtil().setSp(2.5),
                                        ),
                                        Hero(
                                          tag: "Rating-$key",
                                          child: Material(
                                            type: MaterialType.transparency,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: ScreenUtil().setSp(10),
                                                right: ScreenUtil().setSp(10),
                                                bottom: ScreenUtil().setSp(5),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  RatingStars(
                                                    value: productModel.rating
                                                        .toDouble(),
                                                    starBuilder:
                                                        (index, color) => Icon(
                                                      Icons.star,
                                                      color: color,
                                                      size: ScreenUtil()
                                                          .setSp(17),
                                                    ),
                                                    starCount: 5,
                                                    starSize:
                                                        ScreenUtil().setSp(15),
                                                    valueLabelColor:
                                                        const Color(0xff9b9b9b),
                                                    valueLabelTextStyle:
                                                        TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: ScreenUtil()
                                                          .setSp(12),
                                                    ),
                                                    valueLabelRadius:
                                                        ScreenUtil().setSp(20),
                                                    maxValue: 5,
                                                    starSpacing: 1,
                                                    maxValueVisibility: true,
                                                    valueLabelVisibility: true,
                                                    animationDuration:
                                                        const Duration(
                                                            milliseconds: 800),
                                                    valueLabelPadding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          ScreenUtil().setSp(5),
                                                      horizontal:
                                                          ScreenUtil().setSp(5),
                                                    ),
                                                    valueLabelMargin:
                                                        EdgeInsets.only(
                                                      right:
                                                          ScreenUtil().setSp(3),
                                                    ),
                                                    starOffColor: Colors.white,
                                                    starColor: darklogoColor,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        ScreenUtil().setSp(2),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "(${productModel.ratingNo.toString()})",
                                                      style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(13),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: darklogoColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // OurSizedBox(),
                                        Hero(
                                          tag: "Price-$key",
                                          child: Container(
                                            margin: EdgeInsets.only(top: 2),
                                            child: FxText.b2(
                                              "Rs. " +
                                                  productModel.price.toString(),
                                              fontSize: ScreenUtil().setSp(15),
                                              fontWeight: 700,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.contain,
                          height: ScreenUtil().setSp(100),
                          width: ScreenUtil().setSp(100),
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
                          "We cannot find any matches",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.contain,
                        height: ScreenUtil().setSp(100),
                        width: ScreenUtil().setSp(100),
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
                        "We cannot find any matches",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Center(
                child: OurSpinner(),
              );

              // return CircularProgressIndicator();
              // rethrow
            },
          )
        ],
      ),
    );
  }
}
