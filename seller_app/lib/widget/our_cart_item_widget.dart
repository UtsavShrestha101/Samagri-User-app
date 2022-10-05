import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/models/cart_product_model.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_sized_box.dart';

import '../services/firestore_service/product_detail.dart';

class OurCartItemWidget extends StatefulWidget {
  final CartProductModel cartProductModel;
  const OurCartItemWidget({Key? key, required this.cartProductModel})
      : super(key: key);

  @override
  State<OurCartItemWidget> createState() => _OurCartItemWidgetState();
}

class _OurCartItemWidgetState extends State<OurCartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return FxContainer(
      margin: EdgeInsets.symmetric(
        vertical: ScreenUtil().setSp(5),
      ),
      padding: EdgeInsets.all(
        ScreenUtil().setSp(10),
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: CachedNetworkImage(
              height: ScreenUtil().setSp(90),
              fit: BoxFit.fill,
              imageUrl: widget.cartProductModel.url[0],
              placeholder: (context, url) => Image.asset(
                "assets/images/placeholder.png",
                height: ScreenUtil().setSp(90),
                fit: BoxFit.fill,
              ),
            ),
          ),
          FxSpacing.width(
            ScreenUtil().setSp(10),
          ),
          Expanded(
            child: Container(
              height: ScreenUtil().setSp(90),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FxText.b1(
                    widget.cartProductModel.name,
                    fontWeight: 600,
                    letterSpacing: 0,
                    fontSize: ScreenUtil().setSp(17),
                  ),
                  FxText.sh2(
                    "Rs " + widget.cartProductModel.price.toString(),
                    fontWeight: 700,
                    letterSpacing: 0,
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  print("Minus buttom pressed");
                  await ProductDetailFirestore()
                      .deleteItemFromCart(widget.cartProductModel);
                  // if (widget.cartProductModel.quantity > 1) {
                  //   await ProductDetailFirestore()
                  //       .decreaseProductCount(widget.cartProductModel);
                  // }
                  // if (_count > 1) {
                  //   setState(() {
                  //     _count--;
                  //     print("tapped");
                  //   });
                  // }
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setSp(5),
                    left: ScreenUtil().setSp(5),
                    top: ScreenUtil().setSp(4),
                    bottom: ScreenUtil().setSp(4),
                  ),
                  padding: EdgeInsets.only(
                    right: ScreenUtil().setSp(5),
                    left: ScreenUtil().setSp(5),
                    top: ScreenUtil().setSp(4),
                    bottom: ScreenUtil().setSp(4),
                  ),
                  child: Icon(
                    MdiIcons.delete,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              OurSizedBox(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      print("Minus buttom pressed");
                      // await HapticFeedback.vibrate();
                      if (widget.cartProductModel.quantity > 1) {
                        await ProductDetailFirestore()
                            .decreaseProductCount(widget.cartProductModel);
                      }
                      // if (_count > 1) {
                      //   setState(() {
                      //     _count--;
                      //     print("tapped");
                      //   });
                      // }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: logoColor,
                      ),
                      margin: EdgeInsets.only(
                        right: ScreenUtil().setSp(5),
                        left: ScreenUtil().setSp(5),
                        top: ScreenUtil().setSp(4),
                        bottom: ScreenUtil().setSp(4),
                      ),
                      padding: EdgeInsets.only(
                        right: ScreenUtil().setSp(5),
                        left: ScreenUtil().setSp(5),
                        top: ScreenUtil().setSp(4),
                        bottom: ScreenUtil().setSp(4),
                      ),
                      child: Icon(
                        MdiIcons.minus,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Container(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: FxText.sh2(
                        widget.cartProductModel.quantity.toString(),
                        fontWeight: 700,
                        fontSize: ScreenUtil().setSp(17.5),
                        // key: ValueKey<int?>(_count),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      print("Add button pressed");
                      // await HapticFeedback.vibrate();
                      // HapticFeedback.vibrate();
                      // await HapticFeedback.vibrate();
                      // await HapticFeedback.heavyImpact();
                      // await HapticFeedback.lightImpact();
                      // await HapticFeedback.selectionClick();
                      await ProductDetailFirestore()
                          .increaseProductCount(widget.cartProductModel);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: logoColor,
                      ),
                      margin: EdgeInsets.only(
                        right: ScreenUtil().setSp(5),
                        left: ScreenUtil().setSp(5),
                        top: ScreenUtil().setSp(4),
                        bottom: ScreenUtil().setSp(4),
                      ),
                      padding: EdgeInsets.only(
                        right: ScreenUtil().setSp(5),
                        left: ScreenUtil().setSp(5),
                        top: ScreenUtil().setSp(4),
                        bottom: ScreenUtil().setSp(4),
                      ),
                      child: Icon(
                        MdiIcons.plus,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
