import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myapp/controller/search_text_controller.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:myapp/widget/our_spinner.dart';

import '../../models/product_model.dart';
import '../../widget/our_product_grid_loading_widget.dart';
import '../../widget/our_search_product_tile.dart';
import '../../widget/our_text_field.dart';

class ShoppingSearchProductScreen extends StatefulWidget {
  const ShoppingSearchProductScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingSearchProductScreen> createState() =>
      _ShoppingSearchProductScreenState();
}

class _ShoppingSearchProductScreenState
    extends State<ShoppingSearchProductScreen> {
  String searchText = "";
  TextEditingController _search_controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Get.find<SearchTextController>().clearController();
  }

  int tag = -11;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(10),
              vertical: ScreenUtil().setSp(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: ScreenUtil().setSp(30),
                          color: darklogoColor,
                        ),
                      ),
                      Obx(
                        () => Expanded(
                          child: CustomTextField(
                            width: 5,
                            height: 40,
                            autofocus: true,
                            letterlength: 1000,
                            // initialValue: Get.find<SearchTextController>()
                            //     .searchText
                            //     .value,
                            controller: Get.find<SearchTextController>()
                                .search_controller
                                .value,
                            onchange: (value) {
                              print("Hello ");
                              print(value);
                              Get.find<SearchTextController>()
                                  .changeValue(value);
                              print(Get.find<SearchTextController>()
                                  .search_controller
                                  .value
                                  .text);
                            },
                            validator: (value) {},
                            title: "Search Product",
                            type: TextInputType.name,
                            number: 1,
                            length: 1,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.find<SearchTextController>().clearController();
                        },
                        icon: Icon(
                          Icons.delete,
                          size: ScreenUtil().setSp(30),
                          color: darklogoColor,
                        ),
                      ),
                    ],
                  ),
                  OurSizedBox(),
                  Obx(
                    () => Get.find<SearchTextController>()
                                .searchText
                                .value
                                .trim() ==
                            ""
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Search History",
                                    style: TextStyle(
                                      color: logoColor,
                                      fontSize: ScreenUtil().setSp(20),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Hive.box<String>("product_history")
                                          .clear();
                                    },
                                    child: Text(
                                      "Clear",
                                      style: TextStyle(
                                        color: logoColor,
                                        fontSize: ScreenUtil().setSp(17.5),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              OurSizedBox(),
                              ValueListenableBuilder(
                                valueListenable:
                                    Hive.box<String>("product_history")
                                        .listenable(),
                                builder: (context, Box<String> boxs, child) {
                                  var value = boxs.keys;

                                  print("===========");
                                  print(value);
                                  // return InkWell(
                                  //     onTap: () {
                                  //       print(value);
                                  //     },
                                  //     child: Text("data"));
                                  return SizedBox(
                                    height: ScreenUtil().setSp(30),
                                    child: ListView.builder(
                                        itemCount: value.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          String? name =
                                              boxs.get(value.elementAt(index));
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: ScreenUtil().setSp(4),
                                            ),
                                            child: ChoiceChip(
                                              selectedColor:
                                                  logoColor.withOpacity(0.4),
                                              label: Text(
                                                name ?? "",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(15),
                                                ),
                                              ),
                                              selected: tag == index,
                                              onSelected: (bool selected) {
                                                setState(() {
                                                  tag = selected ? index : 0;
                                                  //   if (index == 0) {
                                                  //
                                                  //   }
                                                  setState(() {});
                                                  Get.find<
                                                          SearchTextController>()
                                                      .changeValue(boxs.get(
                                                              value.elementAt(
                                                                  index)) ??
                                                          "");
                                                  print("Utsav");
                                                  print(Get.find<
                                                          SearchTextController>()
                                                      .searchText
                                                      .value);
                                                  print("Utkrista");
                                                });
                                              },
                                            ),
                                          );
                                        }),
                                  );
                                  // return value == 0
                                  //     ? OnboardingScreen()
                                  //     : value == 1
                                  //         ? ShoppingLoginScreen()
                                  //         : ShoppingFullApp();
                                },
                              ),
                            ],
                          )
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("All")
                                .where("searchfrom",
                                    arrayContains:
                                        Get.find<SearchTextController>()
                                            .searchText
                                            .value
                                            .trim()
                                            .toLowerCase())
                                // .orderBy("timestamp", descending: true)
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return OurSpinner();
                              } else if (snapshot.hasData) {
                                if (snapshot.data!.docs.length > 0) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        ProductModel productModel =
                                            ProductModel.fromMap(
                                                snapshot.data!.docs[index]);
                                        return OurSearchProductListTile(
                                          productModel: productModel,
                                          buildContext: context,
                                        );
                                      });
                                }
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
                                        "We are sorry",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: logoColor,
                                          fontSize: ScreenUtil().setSp(17.5),
                                        ),
                                      ),
                                      OurSizedBox(),
                                      Text(
                                        "We cannot find any matches for your search term",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: ScreenUtil().setSp(15),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/logo.png",
                                    fit: BoxFit.contain,
                                    height: ScreenUtil().setSp(100),
                                    width: ScreenUtil().setSp(100),
                                  ),
                                  OurSizedBox(),
                                  Text(
                                    "We are sorry",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: logoColor,
                                      fontSize: ScreenUtil().setSp(17.5),
                                    ),
                                  ),
                                  OurSizedBox(),
                                  Text(
                                    "We cannot find any matches for your search term",
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: ScreenUtil().setSp(15),
                                    ),
                                  ),
                                ],
                              );
                            }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
