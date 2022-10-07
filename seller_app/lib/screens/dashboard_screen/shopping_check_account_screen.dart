import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/widget/our_sized_box.dart';

import '../../controller/check_out_screen_controller.dart';
import '../../controller/delivery_time_controller.dart';
import '../../controller/login_controller.dart';
import '../../utils/color.dart';
import '../../widget/our_spinner.dart';
import '../checkout_screen_units/checkout_payment_unit.dart';
import '../checkout_screen_units/checkout_placed_unit.dart';
import '../checkout_screen_units/checkout_shipping_unit.dart';

class ShoppingCheckOutScreen extends StatefulWidget {
  final double totalPrice;
  const ShoppingCheckOutScreen({Key? key, required this.totalPrice})
      : super(key: key);

  @override
  State<ShoppingCheckOutScreen> createState() => _ShoppingCheckOutScreenState();
}

class _ShoppingCheckOutScreenState extends State<ShoppingCheckOutScreen>
    with TickerProviderStateMixin {
  late AnimationController animationControllerListPage;
  late Animation<double> logoAnimationList;
  late Animation<double> fadeAnimation;
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<CheckOutScreenController>().initialize();
    Get.find<DeliveryTimeController>().initialize();
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

  @override
  void dispose() {
    animationController.dispose();
    animationControllerListPage.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: darklogoColor,
              size: ScreenUtil().setSp(25),
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
                "CheckOut",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil().setSp(25),
                  color: darklogoColor,
                ),
              ),
            ],
          ),
          actions: [
            Opacity(
              opacity: 0,
              child: Icon(Icons.abc),
            ),
          ],
        ),
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: Get.find<LoginController>().processing.value,
            progressIndicator: OurSpinner(),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(5),
                  vertical: ScreenUtil().setSp(5),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.find<CheckOutScreenController>()
                                  .changeIndex(0);
                            },
                            child: Container(
                              height: ScreenUtil().setSp(80),
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setSp(10),
                                vertical: ScreenUtil().setSp(5),
                              ),
                              decoration: BoxDecoration(
                                color: Get.find<CheckOutScreenController>()
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
                                      "Shipping",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17.5),
                                        color:
                                            Get.find<CheckOutScreenController>()
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
                                      Icons.local_shipping_outlined,
                                      size: ScreenUtil().setSp(25),
                                      color:
                                          Get.find<CheckOutScreenController>()
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
                            child: Container(
                              height: ScreenUtil().setSp(80),
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setSp(10),
                                vertical: ScreenUtil().setSp(5),
                              ),
                              decoration: BoxDecoration(
                                color: Get.find<CheckOutScreenController>()
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
                                      "Payment",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17.5),
                                        color:
                                            Get.find<CheckOutScreenController>()
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
                                      Icons.payment,
                                      size: ScreenUtil().setSp(25),
                                      color:
                                          Get.find<CheckOutScreenController>()
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
                        Expanded(
                          child: Container(
                            height: ScreenUtil().setSp(80),
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setSp(10),
                              vertical: ScreenUtil().setSp(5),
                            ),
                            decoration: BoxDecoration(
                              color: Get.find<CheckOutScreenController>()
                                          .index
                                          .value ==
                                      2
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
                                    "Placed",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(17.5),
                                      color:
                                          Get.find<CheckOutScreenController>()
                                                      .index
                                                      .value ==
                                                  2
                                              ? Colors.white
                                              : darklogoColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  OurSizedBox(),
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: ScreenUtil().setSp(25),
                                    color: Get.find<CheckOutScreenController>()
                                                .index
                                                .value ==
                                            2
                                        ? Colors.white
                                        : darklogoColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    OurSizedBox(),
                    Get.find<CheckOutScreenController>().index.value == 0
                        ? CheckOutShipmentUnit()
                        : Get.find<CheckOutScreenController>().index.value == 1
                            ? CheckOutPaymentScreen(
                                totalPrice: widget.totalPrice,
                              )
                            : CheckOutPlacedScreen()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
