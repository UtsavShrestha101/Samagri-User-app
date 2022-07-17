import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/utils/color.dart';

import '../screens/dashboard_screen/shopping_product_screen.dart';
import '../services/firestore_service/userprofile_detail.dart';
import '../utils/generator.dart';

class OurProductListTile extends StatefulWidget {
  final String name, image, shopName;
  final double star;
  final double price;
  final ProductModel productModel;
  final BuildContext buildContext;
  const OurProductListTile({
    Key? key,
    required this.name,
    required this.image,
    required this.shopName,
    required this.star,
    required this.price,
    required this.buildContext,
    required this.productModel,
  }) : super(key: key);

  @override
  State<OurProductListTile> createState() => _OurProductListTileState();
}

class _OurProductListTileState extends State<OurProductListTile> {
  @override
  Widget build(BuildContext context) {
    String key = Generator.randomString(10);
    return InkWell(
      onTap: () {
        Navigator.push(
          widget.buildContext,
          MaterialPageRoute(
            builder: (context) => ShoppingProductScreen(
              heroTag: key, productModel: widget.productModel,
              // image: widget.image,
            ),
          ),
        );
      },
      child: FxContainer(
        padding: EdgeInsets.all(
          ScreenUtil().setSp(20),
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
                child: CachedNetworkImage(
                  height: ScreenUtil().setSp(90),
                  width: ScreenUtil().setSp(90),
                  // width: double.infinity,
                  fit: BoxFit.fill,
                  imageUrl: widget.image,
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
                        FxText.sh1(
                          widget.name,
                          fontWeight: 600,
                          letterSpacing: 0,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(15),
                            fontWeight: FontWeight.w400,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        widget.productModel.favorite.contains(
                                FirebaseAuth.instance.currentUser!.uid)
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
                                  await UserDetailFirestore()
                                      .addFavorite(widget.productModel);
                                  print("Favourite Added");
                                },
                                child: Icon(
                                  MdiIcons.heartOutline,
                                  color: Colors.white,
                                  size: ScreenUtil().setSp(20),
                                ),
                              ),
                      ],
                    ),
                    RatingStars(
                      value: widget.star,
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
                      starColor: Colors.yellow,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                widget.shopName,
                                color: darklogoColor,
                                fontWeight: 500,
                              ),
                            )
                          ],
                        ),
                        FxText.b2(
                          "Rs " + widget.price.toString(),
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(15),
                            fontWeight: FontWeight.w400,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
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
