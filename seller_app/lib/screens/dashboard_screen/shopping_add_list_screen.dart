import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/screens/shopping_list/history_shopping_list.dart';
import 'package:myapp/screens/shopping_list/present_shopping_list.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_sized_box.dart';

class ShoppingAddListScreen extends StatefulWidget {
  const ShoppingAddListScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingAddListScreen> createState() => _ShoppingAddListScreenState();
}

class _ShoppingAddListScreenState extends State<ShoppingAddListScreen>
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

  int select = 0;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        onHorizontalDragEnd: (dragDetail) {
          if (dragDetail.velocity.pixelsPerSecond.dx < 1) {
            if (select < 1) {
              print("Right");
              setState(() {
                select++;
              });
            }
          } else {
            if (select > 0) {
              print("left");
              setState(() {
                select--;
              });
            }
          }
        },
        child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
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
                      "Shopping Lists",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(25),
                        color: darklogoColor,
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setSp(10),
                  left: ScreenUtil().setSp(10),
                  right: ScreenUtil().setSp(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    select = 0;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "Present",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(20),
                                        color: logoColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    select == 0
                                        ? SizedBox(
                                            height: ScreenUtil().setSp(2),
                                          )
                                        : Container(),
                                    select == 0
                                        ? Container(
                                            height: ScreenUtil().setSp(2),
                                            width: double.infinity,
                                            color: darklogoColor,
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    select = 1;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "History",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(20),
                                        color: logoColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    select == 1
                                        ? SizedBox(
                                            height: ScreenUtil().setSp(2),
                                          )
                                        : Container(),
                                    select == 1
                                        ? Container(
                                            height: ScreenUtil().setSp(2),
                                            width: double.infinity,
                                            color: darklogoColor,
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      OurSizedBox(),
                      select == 0
                          ? PresentShoppingList()
                          : HistoryShoppingList(),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
