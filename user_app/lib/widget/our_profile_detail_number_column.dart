import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/utils/color.dart';

class OurProfileDetailNumberColumn extends StatelessWidget {
  final String title;
  final String number;
  final Function function;
  const OurProfileDetailNumberColumn(
      {Key? key,
      required this.title,
      required this.number,
      required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(2),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: darklogoColor,
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(17.5),
              ),
            ),
            // OurSizedBox(),
            SizedBox(
              height: ScreenUtil().setSp(5),
            ),
            Text(
              number,
              style: TextStyle(
                color: logoColor,
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(17),
              ),
            )
          ],
        ),
      ),
    );
  }
}
