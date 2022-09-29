import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/screens/outer_layer_screen/outer_layer.dart';

import '../../utils/color.dart';
import '../../widget/our_sized_box.dart';
import '../../widget/our_spinner.dart';
import '../onboarding_screen/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void completed() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OuterLayerScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), completed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
              height: ScreenUtil().setSp(200),
              width: ScreenUtil().setSp(200),
            ),
            OurSizedBox(),
            Hero(
              tag: "Samagri",
              child: Text(
                "Samagri",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(35),
                  fontWeight: FontWeight.w600,
                  color: logoColor,
                ),
              ),
            ),
            const OurSizedBox(),
            const OurSizedBox(),
            const OurSizedBox(),
            OurSpinner()
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: ScreenUtil().setSp(40),
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(5),
          vertical: ScreenUtil().setSp(10),
        ),
        child: Center(
            child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: "Powered by ",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  )
                  // style: paratext,
                  ),
              TextSpan(
                text: 'Harambe Gople Studio',
                style: TextStyle(
                  color: logoColor,
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(15),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
