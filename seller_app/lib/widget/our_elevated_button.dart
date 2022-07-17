import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/utils/color.dart';

class OurElevatedButton extends StatelessWidget {
  final String title;
  final Function function;
  const OurElevatedButton(
      {Key? key, required this.title, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        ScreenUtil().setSp(10),
      ),
      child: SizedBox(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              darklogoColor,
            ),
          ),
          onPressed: () {
            function();
          },
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(
                20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
