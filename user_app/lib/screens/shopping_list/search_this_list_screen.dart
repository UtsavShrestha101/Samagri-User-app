import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/add_list_model.dart';

import '../../models/product_model.dart';
import '../../utils/color.dart';
import '../../widget/our_search_product_tile.dart';
import '../../widget/our_sized_box.dart';

class SearchThisListScreen extends StatefulWidget {
  // final AddListModel addListModel;
  final String date;
  final List itemlist;
  const SearchThisListScreen({
    Key? key,
    required this.date,
    required this.itemlist,
  }) : super(key: key);

  @override
  State<SearchThisListScreen> createState() => _SearchThisListScreenState();
}

class _SearchThisListScreenState extends State<SearchThisListScreen>
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
    // Get.find<ShoppingListSearchController>().initialize();
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
    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.date} Shopping list",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(17.5),
                  fontWeight: FontWeight.w600,
                  color: logoColor,
                ),
              ),
              Divider(
                color: logoColor,
              ),
              OurSizedBox(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.itemlist.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemlist[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(17.5),
                          color: logoColor,
                        ),
                      ),
                      Divider(
                        color: logoColor,
                      ),
                      OurSizedBox(),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("All")
                            .where(
                              "searchfrom",
                              arrayContains:
                                  widget.itemlist[index].toLowerCase(),
                            )
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
                      OurSizedBox(),
                      OurSizedBox(),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
