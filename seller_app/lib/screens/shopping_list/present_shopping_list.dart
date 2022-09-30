import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:myapp/models/add_list_model.dart';
import 'package:myapp/screens/shopping_list/search_this_list_screen.dart';
import 'package:myapp/screens/shopping_list/shopping_list_search.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_flutter_toast.dart';
import 'package:page_transition/page_transition.dart';

import '../../controller/add_item_controller.dart';
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
  List<String> itemList = [];

  var boxxxx = Hive.box<AddListModel>(DatabaseHelper.addtolistDB);
  TextEditingController add_item_controller = TextEditingController();
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    add_item_controller.dispose();
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
            fontWeight: FontWeight.w600,
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
            List<String> listData = boxs
                .get(
                  todayDate,
                  defaultValue: AddListModel(
                    todayDate,
                    itemList,
                  ),
                )!
                .itemList;
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listData.length,
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
                              listData[index],
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(17.5),
                                color: logoColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // print(listData[index]);
                              AddListModel? aa = boxs.get(
                                todayDate,
                                defaultValue: AddListModel(
                                  todayDate,
                                  itemList,
                                ),
                              );
                              print(aa);
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ShoppingListSearch(addListModel: aa!),
                                  type: PageTransitionType.leftToRight,
                                ),
                              );
                              print("Search");
                            },
                            child: Icon(
                              FeatherIcons.search,
                              color: logoColor.withOpacity(0.75),
                              size: ScreenUtil().setSp(22.5),
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setSp(6.5),
                          ),
                          InkWell(
                            onTap: () {
                              OurToast().showErrorToast("Item Deleted");
                              var abc = boxs.get(todayDate);
                              List<String> ourUpdatedList = abc!.itemList;

                              ourUpdatedList.remove(listData[index]);
                              AddListModel addListModel = AddListModel(
                                todayDate,
                                ourUpdatedList,
                              );
                              boxxxx.put(
                                todayDate,
                                addListModel,
                              );
                            },
                            child: Icon(
                              Icons.delete,
                              color: logoColor.withOpacity(0.75),
                              size: ScreenUtil().setSp(22.5),
                            ),
                          ),
                        ],
                      ));
                });
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
            onChanged: (String value) {
              Get.find<AddItemController>().changeText(value);
            },
            onSubmitted: (String value) {
              if (Get.find<AddItemController>().item.isEmpty) {
                OurToast().showErrorToast("Field can't be empty");
              } else {
                var a = boxxxx.containsKey(todayDate);

                if (a == false) {
                  itemList.add(Get.find<AddItemController>().item.value);
                  AddListModel addListModel = AddListModel(todayDate, itemList);
                  // print(addListModel.date);
                  // print(addListModel.itemList);
                  boxxxx.put(todayDate, addListModel);
                } else {
                  AddListModel? box = boxxxx.get(todayDate);
                  List<String>? currentlist = box?.itemList;

                  currentlist!.add(Get.find<AddItemController>().item.value);
                  AddListModel addListModel =
                      AddListModel(todayDate, currentlist);
                  boxxxx.put(todayDate, addListModel);
                }

                setState(() {
                  add_item_controller.clear();
                });
                Get.find<AddItemController>().initializeddd();
              }
            },
            style: TextStyle(
              fontSize: ScreenUtil().setSp(15),
              color: logoColor,
              fontWeight: FontWeight.w500,
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
                  if (Get.find<AddItemController>().item.value.trim().isEmpty) {
                    OurToast().showSuccessToast("Fields can't be empty");
                  } else {
                    var a = boxxxx.containsKey(todayDate);

                    if (a == false) {
                      itemList.add(Get.find<AddItemController>().item.value);
                      AddListModel addListModel =
                          AddListModel(todayDate, itemList);

                      boxxxx.put(todayDate, addListModel);
                    } else {
                      AddListModel? box = boxxxx.get(todayDate);
                      List<String>? currentlist = box?.itemList;

                      currentlist!
                          .add(Get.find<AddItemController>().item.value);
                      AddListModel addListModel =
                          AddListModel(todayDate, currentlist);
                      boxxxx.put(todayDate, addListModel);
                    }

                    setState(() {
                      add_item_controller.clear();
                    });
                    Get.find<AddItemController>().initializeddd();
                  }
                },
                child: Icon(
                  FeatherIcons.plus,
                  size: ScreenUtil().setSp(22.5),
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
        ),
        OurSizedBox(),
        Center(
          child: OurElevatedButton(
            title: "Search this list",
            function: () {
              print("aaa");
              var a = boxxxx.containsKey(todayDate);
              if (a == false) {
                print("eeee");
                OurToast().showErrorToast("No item in the list");
              } else {
                print("bbbb");
                AddListModel? box = boxxxx.get(todayDate);
                List<String>? currentlist = box?.itemList;

                if (currentlist!.isEmpty) {
                  OurToast().showErrorToast("No item in the list");
                } else {
                  print("cccc");
                  print(boxxxx.get(todayDate)!);
                  print(boxxxx.get(todayDate)!.date);
                  print(boxxxx.get(todayDate)!.itemList);
                  var abcd = boxxxx.get(todayDate)!;
                  Navigator.push(
                    context,
                    PageTransition(
                      child: SearchThisListScreen(
                          // addListModel: abcd,
                          date: boxxxx.get(todayDate)!.date,
                          itemlist: boxxxx.get(todayDate)!.itemList,
                          ),
                      type: PageTransitionType.leftToRight,
                    ),
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
