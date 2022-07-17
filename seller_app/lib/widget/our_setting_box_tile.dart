import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/utils/color.dart';

class OurSettingBoxTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function function;
  const OurSettingBoxTile(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          function();
        },
        child: FxContainer.bordered(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Icon(
                iconData,
                color: darklogoColor,
                size: ScreenUtil().setSp(27.5),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: FxText.button(
                  title,
                  fontSize: ScreenUtil().setSp(15),
                  fontWeight: 600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
