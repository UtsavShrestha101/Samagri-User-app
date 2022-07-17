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
  String category = "All";
  final items = [
    "Grocery",
    "Electronic",
    "Beverage",
    "Personal care",
    "Fashain and apparel",
    "Baby care",
    "Bakery and dairy",
    "Eggs and meat",
    "Household items",
    "Kitchen and pet food",
    "Vegitable and fruits",
    "Beauty",
  ];
  int tag = 0;

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
          SizedBox(
            height: ScreenUtil().setSp(30),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setSp(2),
                    vertical: ScreenUtil().setSp(2),
                  ),
                  child: ChoiceChip(
                    selectedColor: logoColor.withOpacity(0.4),
                    label: index == 0
                        ? Text(
                            "All",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(15),
                            ),
                          )
                        : Text(
                            items[index - 1],
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(15),
                            ),
                          ),
                    selected: tag == index,
                    onSelected: (bool selected) {
                      print(index);
                      setState(() {
                        tag = index;
                        if (index == 0) {
                          category = "All";
                        } else {
                          category = items[index - 1];
                        }
                      });
                      print(items[index - 1]);
                    },
                  ),
                );
              },
            ),
          ),
          OurSizedBox(),
          const OurCarousel(),
          const OurSizedBox(),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(category)
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
