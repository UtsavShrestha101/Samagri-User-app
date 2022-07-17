import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/utils/color.dart';

class OurDeliveryAddressTile extends StatelessWidget {
  final String title;
  final String value;
  const OurDeliveryAddressTile(
      {Key? key, required this.title, required this.value})
      : super(key: key);

  get logoColor => null;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(15.5),
            color: darklogoColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(14.5),
              color: logoColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
