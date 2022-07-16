import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import '../screens/dashboard_screen/shopping_product_screen.dart';
import '../services/firestore_service/userprofile_detail.dart';
import '../utils/generator.dart';

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
  late ThemeData theme;

  Widget build(BuildContext context) {
    String key = Generator.randomString(10);
    theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.push(
            widget.rootContext,
            MaterialPageRoute(
                builder: (context) => ShoppingProductScreen(
                      heroTag: key,
                      productModel: widget.productModel,
                      // image: widget.productModel.url,
                    )));
      },
      child: FxContainer.bordered(
        color: Colors.transparent,
        paddingAll: ScreenUtil().setSp(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Hero(
                  tag: key,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        ScreenUtil().setSp(10),
                      ),
                    ),
                    // child: Image.asset(
                    //   widget.image,
                    //   width: MediaQuery.of(context).size.width,
                    // fit: BoxFit.cover,
                    // ),
                    child: CachedNetworkImage(
                      // height: ScreenUtil().setSp(150),
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      imageUrl: widget.productModel.url,
                      placeholder: (context, url) => Image.asset(
                        "assets/images/placeholder.png",
                        width: MediaQuery.of(context).size.width,
                        // width: ScreenUtil().setSp(150),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: ScreenUtil().setSp(7.5),
                  top: ScreenUtil().setSp(7.5),
                  child: widget.productModel.favorite
                          .contains(FirebaseAuth.instance.currentUser!.uid)
                      ? InkWell(
                          onTap: () async {
                            await UserDetailFirestore()
                                .removeFavorite(widget.productModel);
                            print("Favourite Removed");
                          },
                          child: Icon(
                            MdiIcons.heart,
                            color: Colors.red,
                            size: ScreenUtil().setSp(20),
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            print("HELLO WORLD");
                            // await HapticFeedback.vibrate();
                            // await HapticFeedback.heavyImpact();
                            // await HapticFeedback.lightImpact();
                            // await HapticFeedback.selectionClick();
                            await UserDetailFirestore()
                                .addFavorite(widget.productModel);
                            print("Favourite Added");
                            // Check if the device can vibrate
                            // bool canVibrate = await Vibrate.canVibrate;

// Vibrate
// Vibration duration is a constant 500ms because
// it cannot be set to a specific duration on iOS.
                            
                          },
                          child: Icon(
                            MdiIcons.heartOutline,
                            color: Colors.white,
                            size: ScreenUtil().setSp(20),
                          ),
                        ),
                ),
              ],
            ),
            OurSizedBox(),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: ScreenUtil().setSp(6),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FxText.b1(
                    widget.productModel.name,
                    fontWeight: 700,
                    letterSpacing: 0,
                    fontSize: ScreenUtil().setSp(17.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                  OurSizedBox(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setSp(10),
                      right: ScreenUtil().setSp(10),
                      bottom: ScreenUtil().setSp(5),
                    ),
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
                      animationDuration: const Duration(milliseconds: 800),
                      valueLabelPadding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(5),
                        horizontal: ScreenUtil().setSp(5),
                      ),
                      valueLabelMargin: EdgeInsets.only(
                        right: ScreenUtil().setSp(3),
                      ),
                      starOffColor: Colors.white,
                      starColor: Colors.yellow,
                    ),
                  ),
                  // OurSizedBox(),
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    child: FxText.b2(
                      "Rs. " + widget.productModel.price.toString(),
                      fontSize: ScreenUtil().setSp(15),
                      fontWeight: 700,
                      letterSpacing: 0,
                    ),
                  ),
                  OurSizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
