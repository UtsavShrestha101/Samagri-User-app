import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/widget/our_sized_box.dart';

class OurSettingTile extends StatefulWidget {
  final String title;
  final IconData iconData;
  final Function function;
  const OurSettingTile({
    Key? key,
    required this.title,
    required this.iconData,
    required this.function,
  }) : super(key: key);

  @override
  State<OurSettingTile> createState() => _OurSettingTileState();
}

class _OurSettingTileState extends State<OurSettingTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.function();
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Icon(
                  widget.iconData,
                  size: 22,
                ),
              ),
              SizedBox(
                width: ScreenUtil().setSp(20),
              ),
              Expanded(
                child: FxText.b1(
                  widget.title,
                  fontWeight: 600,
                ),
              ),
              Container(
                child: Icon(
                  MdiIcons.chevronRight,
                ),
              ),
            ],
          ),
          // OurSizedBox(),
          Divider(),
          OurSizedBox(),
        ],
      ),
    );
  }
}
