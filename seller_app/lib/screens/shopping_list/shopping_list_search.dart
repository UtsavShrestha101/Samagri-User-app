import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:myapp/controller/shopping_list_search_controller.dart';
import 'package:myapp/models/add_list_model.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_sized_box.dart';

import '../../models/product_model.dart';
import '../../widget/our_search_product_tile.dart';

class ShoppingListSearch extends StatefulWidget {
  final AddListModel addListModel;

  const ShoppingListSearch({Key? key, required this.addListModel})
      : super(key: key);

  @override
  State<ShoppingListSearch> createState() => _ShoppingListSearchState();
}

class _ShoppingListSearchState extends State<ShoppingListSearch>
    with TickerProviderStateMixin {
  late AnimationController animationControllerListPage;
  late Animation<double> logoAnimationList;
  late Animation<double> fadeAnimation;
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animationControllerListPage = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );
    Get.find<ShoppingListSearchController>().initialize();
    logoAnimationList = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
        parent: animationControllerListPage,
        curve: Curves.linear,
      ),
    );
    animationControllerListPage.repeat(reverse: true);
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (dragDetail) {
        if (dragDetail.velocity.pixelsPerSecond.dx < 1) {
          if (Get.find<ShoppingListSearchController>().index.value <
              widget.addListModel.itemList.length - 1) {
            print(Get.find<ShoppingListSearchController>().index.value);
            print("Right swipe");
            Get.find<ShoppingListSearchController>().changeIndex(
                Get.find<ShoppingListSearchController>().index.value + 1);
          }
        } else {
          if (Get.find<ShoppingListSearchController>().index.value > 0) {
            print(Get.find<ShoppingListSearchController>().index.value);
            print("Left swipe");
            Get.find<ShoppingListSearchController>().changeIndex(
                Get.find<ShoppingListSearchController>().index.value - 1);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: logoColor,
              size: ScreenUtil().setSp(27.5),
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotationTransition(
                turns: logoAnimationList,
                child: Image.asset(
                  "assets/images/logo.png",
                  height: ScreenUtil().setSp(23.5),
                  width: ScreenUtil().setSp(23.5),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setSp(7.5),
              ),
              Text(
                "Shopping List Search",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil().setSp(22.0),
                  color: darklogoColor,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(
            // top: ScreenUtil().setSp(4.0),
            left: ScreenUtil().setSp(10),
            right: ScreenUtil().setSp(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(
                  () => Container(
                    height: ScreenUtil().setSp(50),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        widget.addListModel.itemList.length,
                        (index) => Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.find<ShoppingListSearchController>()
                                  .changeIndex(index);
                            },
                            child: Column(
                              children: [
                                Container(
                                  // width: MediaQuery.of(context).size.width * 0.2,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setSp(10),
                                    vertical: ScreenUtil().setSp(10),
                                  ),
                                  child: Text(
                                    widget.addListModel.itemList[index],
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(16.5),
                                      color: logoColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setSp(2),
                                ),
                                Get.find<ShoppingListSearchController>()
                                            .index ==
                                        index
                                    ? Container(
                                        height: ScreenUtil().setSp(2),
                                        width: ScreenUtil().setSp(45),
                                        // width: 30,
                                        color: darklogoColor,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                OurSizedBox(),
                Obx(
                  () => StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("All")
                        .where(
                          "searchfrom",
                          arrayContains: widget
                              .addListModel
                              .itemList[Get.find<ShoppingListSearchController>()
                                  .index
                                  .value]
                              .toLowerCase(),
                        )
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
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
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.225,
                            ),
                            Center(
                              child: Image.asset(
                                "assets/images/logo.png",
                                fit: BoxFit.contain,
                                height: ScreenUtil().setSp(100),
                                width: ScreenUtil().setSp(100),
                              ),
                            ),
                            OurSizedBox(),
                            Center(
                              child: Text(
                                "We are sorry",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: logoColor,
                                  fontSize: ScreenUtil().setSp(17.5),
                                ),
                              ),
                            ),
                            OurSizedBox(),
                            Center(
                              child: Text(
                                "We cannot find any matches for your search term",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: ScreenUtil().setSp(15),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.225,
                          ),
                          Center(
                            child: Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.contain,
                              height: ScreenUtil().setSp(100),
                              width: ScreenUtil().setSp(100),
                            ),
                          ),
                          OurSizedBox(),
                          Center(
                            child: Text(
                              "We are sorry",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: logoColor,
                                fontSize: ScreenUtil().setSp(17.5),
                              ),
                            ),
                          ),
                          OurSizedBox(),
                          Center(
                            child: Text(
                              "We cannot find any matches for your search term",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: ScreenUtil().setSp(15),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
