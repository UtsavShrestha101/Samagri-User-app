import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/utils/color.dart';
import 'package:shimmer/shimmer.dart';

class OurShimmerText extends StatelessWidget {
  final String title;
  const OurShimmerText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: darklogoColor,
      highlightColor: logoColor,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(27),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}