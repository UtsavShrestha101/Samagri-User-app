/*
* File : Shopping Onboarding
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myapp/db/db_helper.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:provider/provider.dart';

import '../../utils/color.dart';
import '../authentication_screens/shopping_login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: FxOnBoarding(
          pages: <PageViewModel>[
            PageViewModel(
              Color(0xffe1ebfa),

              // logoColor.withOpacity(0.2),
              Padding(
                padding: EdgeInsets.all(
                  ScreenUtil().setSp(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Center(
                        child: Image(
                      image: AssetImage('assets/images/illu-1.png'),
                      width: ScreenUtil().setSp(275),
                      height: ScreenUtil().setSp(300),
                    )),
                    OurSizedBox(),
                    Center(
                      child: Text(
                        'Find lots of product\nthat fits you',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20),
                          color: logoColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    OurSizedBox(),
                    // FxText(
                    //     'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                    //     fontWeight: 500),
                  ],
                ),
              ),
            ),
            PageViewModel(
              // Color(0xffbfd4f4),
              Color(0xffd0e0f7),

              // logoColor.withOpacity(0.3),
              Padding(
                padding: EdgeInsets.all(
                  ScreenUtil().setSp(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Center(
                        child: Image(
                      image: AssetImage('assets/images/illu-2.png'),
                      width: ScreenUtil().setSp(275),
                      height: ScreenUtil().setSp(300),
                    )),
                    OurSizedBox(),
                    Center(
                      child: Text(
                        'Secure payment\nwith SSL ',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20),
                          color: logoColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    OurSizedBox(),
                  ],
                ),
              ),
            ),
            PageViewModel(
              Color(0xffbfd4f4),

              // logoColor.withOpacity(0.4),
              Padding(
                padding: EdgeInsets.all(
                  ScreenUtil().setSp(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                        child: Image(
                      image: AssetImage('assets/images/illu-3.png'),
                      width: ScreenUtil().setSp(275),
                      height: ScreenUtil().setSp(300),
                    )),
                    // SizedBox(height: 30),
                    OurSizedBox(),
                    Center(
                      child: Text(
                        'Fast delivery\nat a snap',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20),
                          color: logoColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // SizedBox(height: 16),
                    OurSizedBox(),
                  ],
                ),
              ),
            ),
          ],
          unSelectedIndicatorColor: logoColor.withOpacity(0.2),
          selectedIndicatorColor: darklogoColor,
          doneWidget: InkWell(
            onTap: () async {
           await   Hive.box<int>(DatabaseHelper.outerlayerDB).put("state", 1);
            },
            child: Container(
              padding: EdgeInsets.all(
                ScreenUtil().setSp(10),
              ),
              child: Text(
                "DONE",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(17.5),
                  color: logoColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          skipWidget: InkWell(
            onTap: () async {
            await  Hive.box<int>(DatabaseHelper.outerlayerDB).put("state", 1);
            },
            child: Container(
              padding: EdgeInsets.all(
                ScreenUtil().setSp(10),
              ),
              child: Text(
                "SKIP",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(17.5),
                  color: logoColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
