import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myapp/screens/shopping_list/shopping_list_search.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_elevated_button.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:page_transition/page_transition.dart';

import '../../db/db_helper.dart';
import '../../models/add_list_model.dart';
import '../../utils/utils.dart';
import '../../widget/our_flutter_toast.dart';

class HistoryShoppingList extends StatefulWidget {
  const HistoryShoppingList({Key? key}) : super(key: key);

  @override
  State<HistoryShoppingList> createState() => _HistoryShoppingListState();
}

class _HistoryShoppingListState extends State<HistoryShoppingList> {
  late String todayDate;
  @override
  void initState() {
    super.initState();

    todayDate = Utils().customDate(
      DateTime.now().add(
        Duration(days: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
          valueListenable:
              Hive.box<AddListModel>(DatabaseHelper.addtolistDB).listenable(),
          builder: (context, Box<AddListModel> boxs, child) {
            List listData = boxs.keys.toList();
            var aaaabbbb = listData;
            aaaabbbb.remove(todayDate);
            return aaaabbbb.isNotEmpty
                ? ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listData.length,
                    itemBuilder: (context, index) {
                      var aa =
                          Hive.box<AddListModel>(DatabaseHelper.addtolistDB)
                              .get(listData[index])!;
                      return todayDate != listData[index]
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${listData[index]} Shopping list",
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(17.5),
                                    fontWeight: FontWeight.w600,
                                    color: logoColor,
                                  ),
                                ),
                                Divider(
                                  color: logoColor,
                                ),
                                OurSizedBox(),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: aa.itemList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: ScreenUtil().setSp(10),
                                            vertical: ScreenUtil().setSp(5),
                                          ),
                                          margin: EdgeInsets.symmetric(
                                            horizontal: ScreenUtil().setSp(10),
                                            vertical: ScreenUtil().setSp(5),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  aa.itemList[index],
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(17.5),
                                                    color: logoColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: ScreenUtil().setSp(4),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    PageTransition(
                                                      child: ShoppingListSearch(
                                                          addListModel: aa),
                                                      type: PageTransitionType
                                                          .leftToRight,
                                                    ),
                                                  );
                                                  // OurToast().showErrorToast("Item Deleted");
                                                  // var abc = boxs.get(todayDate);
                                                  // List<String> ourUpdatedList = abc!.itemList;

                                                  // ourUpdatedList.remove(listData[index]);
                                                  // AddListModel addListModel = AddListModel(
                                                  //   todayDate,
                                                  //   ourUpdatedList,
                                                  // );
                                                  // boxxxx.put(
                                                  //   todayDate,
                                                  //   addListModel,
                                                  // );
                                                },
                                                child: Icon(
                                                  FeatherIcons.search,
                                                  color: logoColor
                                                      .withOpacity(0.75),
                                                  size:
                                                      ScreenUtil().setSp(22.5),
                                                ),
                                              ),
                                            ],
                                          ));
                                    }),
                                OurSizedBox(),
                              ],
                            )
                          : Container();
                    })
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.225,
                      ),
                      Center(
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.contain,
                          height: ScreenUtil().setSp(100),
                          width: ScreenUtil().setSp(100),
                        ),
                      ),
                      OurSizedBox(),
                      Center(
                        child: Text(
                          "We are sorry",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: logoColor,
                            fontSize: ScreenUtil().setSp(17.5),
                          ),
                        ),
                      ),
                      OurSizedBox(),
                      Center(
                        child: Text(
                          "We cannot find any previous shopping list",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                    ],
                  );
            // return ListView.builder(
            // shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            // itemCount: listData.length,
            //     itemBuilder: (context, index) {
            //       return Container(
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //           ),
            //           padding: EdgeInsets.symmetric(
            //             horizontal: ScreenUtil().setSp(10),
            //             vertical: ScreenUtil().setSp(5),
            //           ),
            //           margin: EdgeInsets.symmetric(
            //             horizontal: ScreenUtil().setSp(10),
            //             vertical: ScreenUtil().setSp(5),
            //           ),
            //           child: Row(
            //             children: [
            //               Expanded(
            //                 child: Text(
            //                   listData[index],
            //                   style: TextStyle(
            //                     fontSize: ScreenUtil().setSp(17.5),
            //                     color: logoColor,
            //                     fontWeight: FontWeight.w400,
            //                   ),
            //                 ),
            //               ),
            //               InkWell(
            //                 onTap: () {
            //                   print("Search");
            //                 },
            //                 child: Icon(
            //                   FeatherIcons.search,
            //                   color: logoColor.withOpacity(0.75),
            //                   size: ScreenUtil().setSp(22.5),
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: ScreenUtil().setSp(4),
            //               ),
            //               InkWell(
            //                 onTap: () {
            //                   // OurToast().showErrorToast("Item Deleted");
            //                   // var abc = boxs.get(todayDate);
            //                   // List<String> ourUpdatedList = abc!.itemList;

            //                   // ourUpdatedList.remove(listData[index]);
            //                   // AddListModel addListModel = AddListModel(
            //                   //   todayDate,
            //                   //   ourUpdatedList,
            //                   // );
            //                   // boxxxx.put(
            //                   //   todayDate,
            //                   //   addListModel,
            //                   // );
            //                 },
            //                 child: Icon(
            //                   Icons.delete,
            //                   color: logoColor.withOpacity(0.75),
            //                   size: ScreenUtil().setSp(22.5),
            //                 ),
            //               ),
            //             ],
            //           ));
            //     });
          },
        ),
      ],
    );
  }
}
