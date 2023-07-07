import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/controller/message_toggle_controller.dart';
import 'package:myapp/models/driver_model.dart';
import 'package:myapp/screens/dashboard_screen/shopping_chat_send_screen.dart';
import 'package:myapp/screens/dashboard_screen/shopping_driver_chat_screen.dart';
import 'package:myapp/widget/our_driver_chat.dart';
import 'package:myapp/widget/our_seller_chat.dart';
import 'package:myapp/widget/our_spinner.dart';
import 'package:page_transition/page_transition.dart';

import '../../controller/check_out_screen_controller.dart';
import '../../models/messanger_home_model.dart';
import '../../models/user_model.dart';
import '../../models/user_model_firebase.dart';
import '../../utils/color.dart';
import '../../widget/our_sized_box.dart';

class ShoppingChatScreen extends StatefulWidget {
  const ShoppingChatScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingChatScreen> createState() => _ShoppingChatScreenState();
}

class _ShoppingChatScreenState extends State<ShoppingChatScreen>
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
    Get.find<MessageToggleScreenController>().initialize();
  }

  @override
  void dispose() {
    animationController.dispose();
    animationControllerListPage.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Messages",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(25),
                color: darklogoColor,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() => GestureDetector(
            onHorizontalDragEnd: (dragDetail) {
              if (dragDetail.velocity.pixelsPerSecond.dx < 1) {
                if (Get.find<MessageToggleScreenController>().index.value < 1) {
                  // print(Get.find<DashboardController>().indexs.value);
                  print("Right swipe");
                  Get.find<MessageToggleScreenController>().changeIndex(
                      Get.find<MessageToggleScreenController>().index.value +
                          1);
                }
              } else {
                if (Get.find<MessageToggleScreenController>().index.value > 0) {
                  // print(Get.find<DashboardController>().indexs.value);
                  print("Left swipe");
                  Get.find<MessageToggleScreenController>().changeIndex(
                      Get.find<MessageToggleScreenController>().index.value -
                          1);
                }
              }
            },
            child: Container(
              padding: EdgeInsets.only(
                top: ScreenUtil().setSp(10),
                left: ScreenUtil().setSp(10),
                right: ScreenUtil().setSp(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.find<MessageToggleScreenController>()
                                .changeIndex(0);
                          },
                          child: Container(
                            height: ScreenUtil().setSp(80),
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setSp(10),
                              vertical: ScreenUtil().setSp(5),
                            ),
                            decoration: BoxDecoration(
                              color: Get.find<MessageToggleScreenController>()
                                          .index
                                          .value ==
                                      0
                                  ? darklogoColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                ScreenUtil().setSp(17.5),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Seller",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(17.5),
                                      color:
                                          Get.find<MessageToggleScreenController>()
                                                      .index
                                                      .value ==
                                                  0
                                              ? Colors.white
                                              : darklogoColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  OurSizedBox(),
                                  Icon(
                                    Icons.shop_outlined,
                                    size: ScreenUtil().setSp(25),
                                    color:
                                        Get.find<MessageToggleScreenController>()
                                                    .index
                                                    .value ==
                                                0
                                            ? Colors.white
                                            : darklogoColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.find<MessageToggleScreenController>()
                                .changeIndex(1);
                          },
                          child: Container(
                            height: ScreenUtil().setSp(80),
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setSp(10),
                              vertical: ScreenUtil().setSp(5),
                            ),
                            decoration: BoxDecoration(
                              color: Get.find<MessageToggleScreenController>()
                                          .index
                                          .value ==
                                      1
                                  ? darklogoColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                ScreenUtil().setSp(17.5),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Driver",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(17.5),
                                      color:
                                          Get.find<MessageToggleScreenController>()
                                                      .index
                                                      .value ==
                                                  1
                                              ? Colors.white
                                              : darklogoColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  OurSizedBox(),
                                  Icon(
                                    Icons.drive_eta,
                                    size: ScreenUtil().setSp(25),
                                    color:
                                        Get.find<MessageToggleScreenController>()
                                                    .index
                                                    .value ==
                                                1
                                            ? Colors.white
                                            : darklogoColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  OurSizedBox(),
                  Get.find<MessageToggleScreenController>().index.value == 0
                      ? OurSellerChat()
                      : OurDriverChat()
                ],
              ),
            ),
          )),
    );
  }
}
