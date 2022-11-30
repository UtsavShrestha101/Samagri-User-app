import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_sized_box.dart';
import '../screens/dashboard_screen/shopping_product_screen.dart';
import '../services/firestore_service/userprofile_detail.dart';
import '../services/network_connection/network_connection.dart';
import '../utils/generator.dart';
import 'our_flutter_toast.dart';

class ProductGridTile extends StatefulWidget {
  final ProductModel productModel;
  final BuildContext rootContext;
  const ProductGridTile(
      {Key? key, required this.rootContext, required this.productModel})
      : super(key: key);

  @override
  State<ProductGridTile> createState() => _ProductGridTileState();
}

class _ProductGridTileState extends State<ProductGridTile> {
  @override
  Widget build(BuildContext context) {
    String key = Generator.randomString(10);
    return InkWell(
      onTap: () {
        Navigator.push(
            widget.rootContext,
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
        color: Colors.transparent,
        padding: EdgeInsets.only(
          left: ScreenUtil().setSp(5),
          right: ScreenUtil().setSp(5),
          bottom: ScreenUtil().setSp(2.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
                      child:
                          // Image.network(
                          //   widget.productModel.url[0],
                          //   height: ScreenUtil().setSp(160),
                          //   width: MediaQuery.of(context).size.width,
                          //   fit: BoxFit.cover,
                          //   // placeholder: (context, url) => Image.asset(
                          //   //   "assets/images/placeholder.png",
                          //   //   width: MediaQuery.of(context).size.width,
                          //   //   // width: ScreenUtil().setSp(150),
                          //   // ),
                          // ),
                          CachedNetworkImage(
                        height: ScreenUtil().setSp(160),
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        imageUrl: widget.productModel.url[0],
                        placeholder: (context, url) => Image.asset(
                          "assets/images/placeholder.png",
                          width: MediaQuery.of(context).size.width,
                          // width: ScreenUtil().setSp(150),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: ScreenUtil().setSp(7.5),
                  top: ScreenUtil().setSp(7.5),
                  child: widget.productModel.favorite
                          .contains(FirebaseAuth.instance.currentUser!.uid)
                      ? Hero(
                          tag: "Liked-$key",
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              onTap: () async {
                                if (Get.find<CheckConnectivity>().isOnline ==
                                    false) {
                                  OurToast().showErrorToast(
                                      "Oops, No internet connection");
                                } else {
                                  await UserDetailFirestore()
                                      .removeFavorite(widget.productModel);
                                }

                                print("Favourite Removed");
                              },
                              child: Icon(
                                MdiIcons.heart,
                                color: Colors.red,
                                size: ScreenUtil().setSp(20),
                              ),
                            ),
                          ))
                      : Hero(
                          tag: "NotLiked-$key",
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              onTap: () async {
                                print("HELLO WORLD");
                                if (Get.find<CheckConnectivity>().isOnline ==
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
                          )),
                ),
              ],
            ),
            // OurSizedBox(),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: "NameTag-$key",
                    child: Material(
                      type: MaterialType.transparency,
                      child: FxText.b1(
                        widget.productModel.name,
                        fontWeight: 700,
                        letterSpacing: 0,
                        color: logoColor,
                        fontSize: ScreenUtil().setSp(17.5),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setSp(2.5),
                  ),
                  // Hero(
                  //   tag: "ShopName-$key",
                  //   child: Material(
                  //     type: MaterialType.transparency,
                  //     child: FxText.b1(
                  //       widget.productModel.shop_name,
                  //       fontWeight: 500,
                  //       letterSpacing: 0,
                  //       color: logoColor,
                  //       fontSize: ScreenUtil().setSp(15),
                  //       overflow: TextOverflow.ellipsis,
                  //     ),
                  //   ),
                  // ),
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: RatingStars(
                                value: widget.productModel.rating.toDouble(),
                                starBuilder: (index, color) => Icon(
                                  Icons.star,
                                  color: color,
                                  size: ScreenUtil().setSp(17),
                                ),
                                starCount: 5,
                                starSize: ScreenUtil().setSp(15),
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
                                animationDuration:
                                    const Duration(milliseconds: 800),
                                valueLabelPadding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setSp(2),
                                  horizontal: ScreenUtil().setSp(2),
                                ),
                                valueLabelMargin: EdgeInsets.only(
                                  right: ScreenUtil().setSp(3),
                                ),
                                starOffColor: Colors.white,
                                starColor: darklogoColor,
                              ),
                            ),
                            // SizedBox(
                            //   width: ScreenUtil().setSp(2),
                            // ),
                            // Expanded(
                            //   child: Text(
                            //     "(${widget.productModel.ratingNo.toString()})",
                            //     style: TextStyle(
                            //       fontSize: ScreenUtil().setSp(13),
                            //       fontWeight: FontWeight.w500,
                            //       color: darklogoColor,
                            //     ),
                            //   ),
                            // ),
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
                        "Rs. " + widget.productModel.price.toString(),
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
  }
}
