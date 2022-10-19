import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'our_shimmer_widget.dart';
import 'our_sized_box.dart';

class OurProductGridLoadingScreen extends StatelessWidget {
  const OurProductGridLoadingScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return GridView.count(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: .8,
                            crossAxisSpacing: ScreenUtil().setSp(5),
                            mainAxisSpacing: ScreenUtil().setSp(5),
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ShimmerWidget.rectangular(
                                    height: ScreenUtil().setSp(100),
                                    width: ScreenUtil().setSp(100),
                                  ),
                                  OurSizedBox(),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(100),
                                    height: ScreenUtil().setSp(15),
                                  ),
                                  OurSizedBox(),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(150),
                                    height: ScreenUtil().setSp(10),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setSp(5),
                                  ),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(150),
                                    height: ScreenUtil().setSp(10),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ShimmerWidget.rectangular(
                                    height: ScreenUtil().setSp(100),
                                    width: ScreenUtil().setSp(100),
                                  ),
                                  OurSizedBox(),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(100),
                                    height: ScreenUtil().setSp(15),
                                  ),
                                  OurSizedBox(),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(150),
                                    height: ScreenUtil().setSp(10),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setSp(5),
                                  ),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(150),
                                    height: ScreenUtil().setSp(10),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ShimmerWidget.rectangular(
                                    height: ScreenUtil().setSp(100),
                                    width: ScreenUtil().setSp(100),
                                  ),
                                  OurSizedBox(),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(100),
                                    height: ScreenUtil().setSp(15),
                                  ),
                                  OurSizedBox(),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(150),
                                    height: ScreenUtil().setSp(10),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setSp(5),
                                  ),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(150),
                                    height: ScreenUtil().setSp(10),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ShimmerWidget.rectangular(
                                    height: ScreenUtil().setSp(100),
                                    width: ScreenUtil().setSp(100),
                                  ),
                                  OurSizedBox(),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(100),
                                    height: ScreenUtil().setSp(15),
                                  ),
                                  OurSizedBox(),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(150),
                                    height: ScreenUtil().setSp(10),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setSp(5),
                                  ),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(150),
                                    height: ScreenUtil().setSp(10),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                // crossAxisAlignment:
                                //     CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ShimmerWidget.rectangular(
                                    height: ScreenUtil().setSp(100),
                                    width: ScreenUtil().setSp(100),
                                  ),
                                  OurSizedBox(),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(100),
                                    height: ScreenUtil().setSp(15),
                                  ),
                                  OurSizedBox(),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(150),
                                    height: ScreenUtil().setSp(10),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setSp(5),
                                  ),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(150),
                                    height: ScreenUtil().setSp(10),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                // crossAxisAlignment:
                                //     CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ShimmerWidget.rectangular(
                                    height: ScreenUtil().setSp(100),
                                    width: ScreenUtil().setSp(100),
                                  ),
                                  OurSizedBox(),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(100),
                                    height: ScreenUtil().setSp(15),
                                  ),
                                  OurSizedBox(),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(150),
                                    height: ScreenUtil().setSp(10),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setSp(5),
                                  ),
                                  ShimmerWidget.rectangular(
                                    width: ScreenUtil().setSp(150),
                                    height: ScreenUtil().setSp(10),
                                  ),
                                ],
                              ),
                            ],
                          );
  }
}