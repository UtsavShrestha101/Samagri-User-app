import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:myapp/screens/dashboard_screen/shopping_search_product_screen.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_product_grid_loading_widget.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:myapp/widget/our_spinner.dart';
import 'package:myapp/widget/our_text_field.dart';
import 'package:page_transition/page_transition.dart';
import '../../controller/search_text_controller.dart';
import '../../models/product_model.dart';
import '../../widget/our_carousel_slider.dart';
import '../../widget/our_product_grid_tile.dart';

class ShoppingHomeScreen extends StatefulWidget {
  const ShoppingHomeScreen({Key? key}) : super(key: key);

  @override
  _ShoppingHomeScreenState createState() => _ShoppingHomeScreenState();
}

class _ShoppingHomeScreenState extends State<ShoppingHomeScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _search_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(
            20, FxSpacing.safeAreaTop(context) + 20, 20, 20),
        children: <Widget>[
          CustomTextField(
            width: 5,
            height: 40,
            letterlength: 1000,
            readonly: true,
            ontap: () {
              Get.find<SearchTextController>().clearController();

              Navigator.push(
                context,
                PageTransition(
                  child: ShoppingSearchProductScreen(),
                  type: PageTransitionType.leftToRight,
                ),
              );
            },
            controller: _search_controller,
            validator: (value) {},
            title: "Search Product",
            type: TextInputType.name,
            number: 1,
          ),
          OurSizedBox(),
          const OurCarousel(),
          const OurSizedBox(),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Products")
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return OurProductGridLoadingScreen();
              } else if (snapshot.hasData) {
                if (snapshot.data!.docs.length > 0) {
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: ScreenUtil().setSp(5),
                        mainAxisSpacing: ScreenUtil().setSp(5),
                        childAspectRatio: 0.59),
                    itemBuilder: (context, index) {
                      ProductModel productModel =
                          ProductModel.fromMap(snapshot.data!.docs[index]);
                      return ProductGridTile(
                        productModel: productModel,
                        rootContext: context,
                      );
                    },
                  );
                } else {
                  return Container();
                }
              } else if (!snapshot.hasData) {
                return Center(
                  child: Image.asset(
                    "assets/images/empty.png",
                    height: ScreenUtil().setSp(200),
                    width: ScreenUtil().setSp(200),
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

// class _ProductListWidget extends StatefulWidget {
//   final String name, image, shopName;
//   final double star;
//   final int price;
//   final BuildContext buildContext;

//   const _ProductListWidget(
//       {Key? key,
//       required this.name,
//       required this.image,
//       required this.shopName,
//       required this.star,
//       required this.price,
//       required this.buildContext})
//       : super(key: key);

//   @override
//   __ProductListWidgetState createState() => __ProductListWidgetState();
// }

// class __ProductListWidgetState extends State<_ProductListWidget> {
//   late ThemeData theme;

//   @override
//   Widget build(BuildContext context) {
//     theme = Theme.of(context);
//     String key = Generator.randomString(10);
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//             widget.buildContext,
//             MaterialPageRoute(
//                 builder: (context) => ShoppingProductScreen(
//                       heroTag: key,
//                       image: widget.image,
//                     )));
//       },
//       child: FxContainer(
//         padding: EdgeInsets.all(20),
//         child: Row(
//           children: <Widget>[
//             Hero(
//               tag: key,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(8)),
//                 child: Image.asset(
//                   widget.image,
//                   height: 90,
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//             FxSpacing.width(20),
//             Expanded(
//               child: Container(
//                 height: 90,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         FxText.sh1(widget.name,
//                             fontWeight: 600, letterSpacing: 0),
//                         Icon(
//                           MdiIcons.heart,
//                           color: theme.colorScheme.onBackground.withAlpha(80),
//                           size: 22,
//                         )
//                       ],
//                     ),
//                     Row(
//                       children: <Widget>[
//                         FxStarRating(
//                             rating: widget.star,
//                             size: 20,
//                             inactiveColor: theme.colorScheme.onBackground),
//                         Container(
//                           margin: EdgeInsets.only(left: 4),
//                           child: FxText.b1(widget.star.toString(),
//                               fontWeight: 600),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Icon(
//                               MdiIcons.storeOutline,
//                               color:
//                                   theme.colorScheme.onBackground.withAlpha(200),
//                               size: 20,
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(left: 4),
//                               child: FxText.b2(widget.shopName,
//                                   color: theme.colorScheme.onBackground
//                                       .withAlpha(200),
//                                   fontWeight: 500),
//                             )
//                           ],
//                         ),
//                         FxText.b2("\$ " + widget.price.toString(),
//                             fontWeight: 700)
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _CategoryWidget extends StatelessWidget {
//   final IconData iconData;
//   final String actionText;
//   final bool isSelected;

//   const _CategoryWidget(
//       {Key? key,
//       required this.iconData,
//       required this.actionText,
//       this.isSelected = false})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return Container(
//       margin: EdgeInsets.only(top: 12, bottom: 12),
//       child: Column(
//         children: <Widget>[
//           ClipOval(
//             child: Material(
//               color: isSelected
//                   ? theme.colorScheme.primary
//                   : theme.colorScheme.primary.withAlpha(20),
//               child: SizedBox(
//                   width: 52,
//                   height: 52,
//                   child: Icon(
//                     iconData,
//                     color: isSelected
//                         ? theme.colorScheme.onPrimary
//                         : theme.colorScheme.primary,
//                   )),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 8),
//             child:
//                 FxText.caption(actionText, fontWeight: 600, letterSpacing: 0),
//           )
//         ],
//       ),
//     );
  // }
// }
