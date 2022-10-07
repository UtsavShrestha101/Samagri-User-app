import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_sized_box.dart';

import '../../controller/dashboard_controller.dart';

class CheckOutPlacedScreen extends StatefulWidget {
  const CheckOutPlacedScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutPlacedScreen> createState() => _CheckOutPlacedScreenState();
}

class _CheckOutPlacedScreenState extends State<CheckOutPlacedScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(
            ScreenUtil().setSp(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              ScreenUtil().setSp(10),
            ),
            child: Image.asset(
              "assets/images/order_success.png",
              height: ScreenUtil().setSp(350),
              width: double.infinity,
            ),
          ),
        ),
        Text(
          "Order Success",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(25),
            color: darklogoColor,
            fontWeight: FontWeight.bold,
            letterSpacing: ScreenUtil().setSp(1.2),
          ),
        ),
        OurSizedBox(),
        Center(
          child: Text(
            'Your packet will be sent to your \naddress, thanks for order',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(15),
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        OurSizedBox(),
        InkWell(
          onTap: () {
            Get.find<DashboardController>().changeIndexs(0);
            Navigator.pop(context);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(4.5),
            ),
            height: ScreenUtil().setSp(40),
            decoration: BoxDecoration(
              color: darklogoColor,
              borderRadius: BorderRadius.circular(
                ScreenUtil().setSp(
                  10,
                ),
              ),
            ),
            child: Center(
              child: Text(
                "Back To Home",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(
                    16,
                  ),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
