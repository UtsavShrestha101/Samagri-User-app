import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/add_list_model.dart';
import 'package:myapp/utils/color.dart';

import '../../db/db_helper.dart';
import '../../utils/utils.dart';
import '../../widget/our_elevated_button.dart';
import '../../widget/our_sized_box.dart';

import 'package:hive_flutter/hive_flutter.dart';

class PresentShoppingList extends StatefulWidget {
  const PresentShoppingList({Key? key}) : super(key: key);

  @override
  State<PresentShoppingList> createState() => _PresentShoppingListState();
}

class _PresentShoppingListState extends State<PresentShoppingList> {
  late String todayDate;
              var itemList = [];

  var boxxxx = Hive.box<AddListModel>(DatabaseHelper.addtolistDB);
  TextEditingController add_item_controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    todayDate = Utils().customDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$todayDate Shopping list",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(17.5),
            color: logoColor,
          ),
        ),
        Divider(
          color: logoColor,
        ),
        OurSizedBox(),
        ValueListenableBuilder(
          valueListenable:
              Hive.box<AddListModel>(DatabaseHelper.addtolistDB).listenable(),
          builder: (context, Box<AddListModel> boxs, child) {
            return OurElevatedButton(
              title: "title",
              function: () {
                var a = boxs.keys;
                print(a);
              },
            );
          },
        ),
        OurSizedBox(),
        Container(
          height: ScreenUtil().setSp(40),
          child: TextField(
            scrollPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            cursorColor: darklogoColor,
            controller: add_item_controller,
            onChanged: (String value) {},
            onSubmitted: (String value) {
              var a = boxxxx.containsKey(todayDate);
              // itemList.add(value)

              AddListModel addListModel = AddListModel(todayDate, itemList);

              if (a = false) {
                // boxxxx.put(todayDate, value)
              } else {
              }
              print(a);
              print("Submit garyo hai hero");
              print("AAA");
            },
            style: TextStyle(
              fontSize: ScreenUtil().setSp(15),
              color: logoColor,
            ),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setSp(10),
                horizontal: ScreenUtil().setSp(2),
              ),
              isDense: true,
              hintText: "Add new Item",
              hintStyle: TextStyle(
                color: logoColor,
                fontSize: ScreenUtil().setSp(
                  17.5,
                ),
              ),
              prefixIcon: InkWell(
                onTap: () {
                  print("object");
                },
                child: Icon(
                  FeatherIcons.plus,
                  size: ScreenUtil().setSp(20),
                  color: logoColor,
                ),
              ),
              errorStyle: TextStyle(
                fontSize: ScreenUtil().setSp(
                  13.5,
                ),
              ),
            ),
            onEditingComplete: () {
              print(add_item_controller.text.trim());
              FocusScope.of(context).unfocus();
            },
          ),
        )
      ],
    );
  }
}
