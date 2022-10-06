import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myapp/controller/search_text_controller.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:myapp/widget/our_spinner.dart';
import '../../models/product_model.dart';
import '../../widget/our_search_product_tile.dart';

class ShoppingSearchProductScreen extends StatefulWidget {
  const ShoppingSearchProductScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingSearchProductScreen> createState() =>
      _ShoppingSearchProductScreenState();
}

class _ShoppingSearchProductScreenState
    extends State<ShoppingSearchProductScreen>
    with SingleTickerProviderStateMixin {
  String searchText = "";
  TextEditingController _search_controller = TextEditingController();

  @override
  void dispose() {
    Get.find<SearchTextController>().clearController();
    super.dispose();
    _search_controller.clear();
  }

  int tag = -11;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(10),
              vertical: ScreenUtil().setSp(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: (() {
                          Get.find<SearchTextController>().clearController();
                          Navigator.pop(context);
                        }),
                        child: Icon(
                          Icons.arrow_back,
                          color: logoColor,
                          size: ScreenUtil().setSp(25),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(15),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(15),
                          ),
                          height: ScreenUtil().setSp(40),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            scrollPadding: EdgeInsets.only(
                              left: ScreenUtil().setSp(15),
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            cursorColor: Colors.white,
                            controller: _search_controller,
                            onChanged: (String value) {
                              Get.find<SearchTextController>()
                                  .changeValue(value);
                            },
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(15),
                              color: logoColor,
                            ),
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
                              hintText: "Explore",
                              hintStyle: TextStyle(
                                color: logoColor,
                                fontSize: ScreenUtil().setSp(
                                  17.5,
                                ),
                              ),
                              errorStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(
                                  13.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _search_controller.clear();
                          });
                          Get.find<SearchTextController>().clearController();
                        },
                        child: Icon(
                          Icons.delete,
                          size: ScreenUtil().setSp(25),
                          color: darklogoColor,
                        ),
                      ),
                    ],
                  ),
                  OurSizedBox(),
                  Obx(
                    () => Get.find<SearchTextController>()
                                .searchText
                                .value
                                .trim() ==
                            ""
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Search History",
                                    style: TextStyle(
                                      color: logoColor,
                                      fontSize: ScreenUtil().setSp(20),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Hive.box<String>("product_history")
                                          .clear();
                                    },
                                    child: Text(
                                      "Clear",
                                      style: TextStyle(
                                        color: logoColor,
                                        fontSize: ScreenUtil().setSp(17.5),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              OurSizedBox(),
                              ValueListenableBuilder(
                                valueListenable:
                                    Hive.box<String>("product_history")
                                        .listenable(),
                                builder: (context, Box<String> boxs, child) {
                                  var value = boxs.keys;

                                  print("===========");
                                  print(value);
                                  // return InkWell(
                                  //     onTap: () {
                                  //       print(value);
                                  //     },
                                  //     child: Text("data"));
                                  return SizedBox(
                                    height: ScreenUtil().setSp(30),
                                    child: ListView.builder(
                                        itemCount: value.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          String? name =
                                              boxs.get(value.elementAt(index));
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: ScreenUtil().setSp(4),
                                            ),
                                            child: ChoiceChip(
                                              selectedColor:
                                                  logoColor.withOpacity(0.4),
                                              label: Text(
                                                name ?? "",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(15),
                                                ),
                                              ),
                                              selected: tag == index,
                                              onSelected: (bool selected) {
                                                setState(() {
                                                  tag = selected ? index : 0;
                                                  //   if (index == 0) {
                                                  //
                                                  //   }
                                                  setState(() {});
                                                  Get.find<
                                                          SearchTextController>()
                                                      .changeValue(boxs.get(
                                                              value.elementAt(
                                                                  index)) ??
                                                          "");
                                                  print("Utsav");
                                                  print(Get.find<
                                                          SearchTextController>()
                                                      .searchText
                                                      .value);
                                                  print("Utkrista");
                                                });
                                              },
                                            ),
                                          );
                                        }),
                                  );
                                  // return value == 0
                                  //     ? OnboardingScreen()
                                  //     : value == 1
                                  //         ? ShoppingLoginScreen()
                                  //         : ShoppingFullApp();
                                },
                              ),
                            ],
                          )
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("All")
                                .where("searchfrom",
                                    arrayContains:
                                        Get.find<SearchTextController>()
                                            .searchText
                                            .value
                                            .trim()
                                            .toLowerCase())
                                // .orderBy("timestamp", descending: true)
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.docs.length > 0) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        ProductModel productModel =
                                            ProductModel.fromMap(
                                                snapshot.data!.docs[index]);
                                        return OurSearchProductListTile(
                                          productModel: productModel,
                                          buildContext: context,
                                        );
                                      });
                                }
                              } else {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.225,
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
                                        "We cannot find any matches for your search term",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: ScreenUtil().setSp(15),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.225,
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
                                      "We cannot find any matches for your search term",
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: ScreenUtil().setSp(15),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// Container(
//       margin: EdgeInsets.symmetric(
//         horizontal: ScreenUtil().setSp( 22.5),
//       ),
//       height: ScreenUtil().setSp( 40),
//       child: TextFormField(
//         // inputFormatters: [
//         //   LengthLimitingTextInputFormatter(widget.letterlength),
//         // ],
//         scrollPadding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         cursorColor: Colors.white,
//         controller: _search_controller,
        
//         onChanged: (String value) {
//           // widget.onchange!(value) ;
//         },
//         // validator: (String? value) => widget.validator(value!),
//         style: TextStyle(
//           fontSize: ScreenUtil().setSp(15),
//           color: logoColor,
//         ),
//         // autofocus: widget.autofocus ?? false,
//         keyboardType: TextInputType.name,
//         // maxLines: widget.length,
//         // onTap: widget.ontap ?? () {},
//         // readOnly: widget.readonly ?? false,
//         decoration: InputDecoration(
//             border: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             focusedBorder: InputBorder.none,

//             // focusedBorder: InputBorder.none,
//             fillColor: Colors.white,
//             filled: true,
//             contentPadding: EdgeInsets.symmetric(
//               vertical: ScreenUtil().setSp(10),
//               horizontal: ScreenUtil().setSp(2),
//             ),
//             isDense: true,
//             hintText: "Keyboard",
//             hintStyle: TextStyle(
//               color: logoColor,
//               fontSize: ScreenUtil().setSp(
//                 17.5,
//               ),
//             ),
//             // prefixIcon: Icon(
//             //   widget.icon,
//             //   size: ScreenUtil().setSp(20),
//             //   color: logoColor,
//             // ),
//             errorStyle: TextStyle(
//               fontSize: ScreenUtil().setSp(
//                 13.5,
//               ),
//             ),
//             // suffixIcon: widget.suffexWidget ?? null),
//         // maxLength: 10,
//       ),