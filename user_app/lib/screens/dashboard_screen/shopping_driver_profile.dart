import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/controller/login_controller.dart';
import 'package:myapp/models/driver_review_model.dart';
import 'package:myapp/models/user_model_firebase.dart';
import 'package:myapp/screens/dashboard_screen/shopping_driver_chat_screen.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_flutter_toast.dart';
import 'package:page_transition/page_transition.dart';

import '../../models/driver_model.dart';
import '../../services/add_review_driver/add_review_driver.dart';
import '../../widget/our_sized_box.dart';
import '../../widget/our_spinner.dart';

class ShoppingDriverProfile extends StatefulWidget {
  final String driverUID;
  const ShoppingDriverProfile({Key? key, required this.driverUID})
      : super(key: key);

  @override
  State<ShoppingDriverProfile> createState() => _ShoppingDriverProfileState();
}

class _ShoppingDriverProfileState extends State<ShoppingDriverProfile> {
  TextEditingController _review_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(() => ModalProgressHUD(
          inAsyncCall: Get.find<LoginController>().processing.value,
          progressIndicator: OurSpinner(),
          child: Scaffold(
              body: SafeArea(
            child: ListView(
              padding: EdgeInsets.all(
                ScreenUtil().setSp(20),
              ),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setSp(16),
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Drivers")
                        .doc(widget.driverUID)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: OurSpinner(),
                        );
                      } else {
                        if (snapshot.hasData) {
                          DriverModel driverModel =
                              DriverModel.fromMap(snapshot.data!.data()!);
                          // FirebaseUserModel firebaseUserModel =
                          //     FirebaseUserModel.fromMap(snapshot.data!.data()!);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: ScreenUtil().setSp(40),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        ScreenUtil().setSp(25),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: driverModel.profile_pic ?? "",

                                        // Image.network(
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          "assets/images/profile_holder.png",
                                          width: double.infinity,
                                          height: ScreenUtil().setSp(125),
                                          fit: BoxFit.fitWidth,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          "assets/images/profile_holder.png",
                                          width: double.infinity,
                                          height: ScreenUtil().setSp(125),
                                          fit: BoxFit.fitWidth,
                                        ),
                                        height: ScreenUtil().setSp(100),
                                        width: ScreenUtil().setSp(100),
                                        fit: BoxFit.cover,
                                        //   )
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setSp(30),
                                  ),
                                  Expanded(
                                    child: Text(
                                      driverModel.user_name ?? "",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(20),
                                        color: darklogoColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      var a = await FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .get();
                                      FirebaseUser11Model userModel11 =
                                          FirebaseUser11Model.fromMap(a);
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: DriverMessageSendScreen(
                                            userModel: userModel11,
                                            driverModel: driverModel,
                                          ),
                                          type: PageTransitionType.leftToRight,
                                        ),
                                      );
                                      // print("Chat Screen");
                                      // print(widget.userModel.name);
                                    },
                                    child: Icon(
                                      MdiIcons.chatOutline,
                                      color: darklogoColor,
                                      size: ScreenUtil().setSp(35),
                                    ),
                                  ),
                                ],
                              ),
                              OurSizedBox(),
                              Row(
                                children: [
                                  Text(
                                    "Total No of deliveries:",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(17.5),
                                      color: darklogoColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setSp(20),
                                  ),
                                  Text(
                                    driverModel.delivered.toString(),
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(20),
                                      color: darklogoColor,
                                    ),
                                  ),
                                ],
                              ),
                              OurSizedBox(),
                              Row(
                                children: [
                                  Text(
                                    "Total No of reviews:",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(17.5),
                                      color: darklogoColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setSp(20),
                                  ),
                                  Text(
                                    driverModel.reviews.toString(),
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(20),
                                      color: darklogoColor,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: darklogoColor,
                              ),
                              Container(
                                // margin: EdgeInsets.symmetric(
                                //   horizontal: ScreenUtil().setSp(10),
                                //   vertical: ScreenUtil().setSp(10),
                                // ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: ScreenUtil().setSp(40),
                                        child: TextFormField(
                                          // textAlign: TextAlign.center,
                                          scrollPadding: EdgeInsets.only(
                                            left: ScreenUtil().setSp(15),
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          cursorColor: Colors.white,
                                          controller: _review_controller,
                                          // onChanged: (String value) {
                                          //   Get.find<SearchTextController>()
                                          //       .changeValue(value);
                                          // },
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
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: ScreenUtil().setSp(10),
                                              horizontal: ScreenUtil().setSp(2),
                                            ),
                                            isDense: true,
                                            hintText: "   Send Review",
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
                                    SizedBox(
                                      width: ScreenUtil().setSp(15),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        if (_review_controller.text
                                            .trim()
                                            .isEmpty) {
                                          OurToast().showErrorToast(
                                              "Field can't be empty");
                                        } else {
                                          Get.find<LoginController>()
                                              .toggle(true);
                                          await AddReviewDriver().addReview(
                                            driverModel,
                                            _review_controller.text.trim(),
                                          );
                                          _review_controller.clear();
                                          Get.find<LoginController>()
                                              .toggle(false);
                                        }
                                      },
                                      child: Icon(
                                        Icons.send,
                                        size: ScreenUtil().setSp(
                                          30,
                                        ),
                                        color: logoColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              OurSizedBox(),
                              driverModel.reviews == 0
                                  ? Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          OurSizedBox(),
                                          OurSizedBox(),
                                          OurSizedBox(),
                                          Image.asset(
                                            "assets/images/logo.png",
                                            fit: BoxFit.contain,
                                            height: ScreenUtil().setSp(100),
                                            width: ScreenUtil().setSp(100),
                                          ),
                                          OurSizedBox(),
                                          Text(
                                            "We're sorry",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: logoColor,
                                              fontSize:
                                                  ScreenUtil().setSp(17.5),
                                            ),
                                          ),
                                          OurSizedBox(),
                                          Text(
                                            "Driver doesn't have any reviews yet",
                                            style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: ScreenUtil().setSp(15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "All Reviews:",
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(20),
                                            color: darklogoColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Divider(
                                          color: darklogoColor,
                                        ),
                                        StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("AllReviews")
                                              .where("driverUID",
                                                  isEqualTo: widget.driverUID)
                                              .orderBy(
                                                "created_On",
                                                descending: true,
                                              )
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasData) {
                                              if (snapshot.data!.docs.length >
                                                  0) {
                                                return ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      DriverReviewModel
                                                          driverReviewModel =
                                                          DriverReviewModel
                                                              .fromMap(snapshot
                                                                  .data!
                                                                  .docs[index]);
                                                      return Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              ScreenUtil()
                                                                  .setSp(7.5),
                                                          vertical: ScreenUtil()
                                                              .setSp(7.5),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            ScreenUtil()
                                                                .setSp(10),
                                                          ),
                                                        ),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              ScreenUtil()
                                                                  .setSp(5),
                                                          vertical: ScreenUtil()
                                                              .setSp(5),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              driverReviewModel
                                                                  .senderName,
                                                              style: TextStyle(
                                                                color:
                                                                    darklogoColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            17.5),
                                                              ),
                                                            ),
                                                            OurSizedBox(),
                                                            Text(
                                                              driverReviewModel
                                                                  .review,
                                                              style: TextStyle(
                                                                color:
                                                                    logoColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            17.5),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              } else {
                                                return Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Spacer(),
                                                      Image.asset(
                                                        "assets/images/logo.png",
                                                        fit: BoxFit.contain,
                                                        height: ScreenUtil()
                                                            .setSp(100),
                                                        width: ScreenUtil()
                                                            .setSp(100),
                                                      ),
                                                      OurSizedBox(),
                                                      Text(
                                                        "We're sorry",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: logoColor,
                                                          fontSize: ScreenUtil()
                                                              .setSp(17.5),
                                                        ),
                                                      ),
                                                      OurSizedBox(),
                                                      Text(
                                                        "You have not sent any messages",
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: ScreenUtil()
                                                              .setSp(15),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                    ],
                                                  ),
                                                );
                                              }
                                            } else if (snapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              return OurSpinner();
                                            }
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Spacer(),
                                                  Image.asset(
                                                    "assets/images/logo.png",
                                                    fit: BoxFit.contain,
                                                    height:
                                                        ScreenUtil().setSp(100),
                                                    width:
                                                        ScreenUtil().setSp(100),
                                                  ),
                                                  OurSizedBox(),
                                                  Text(
                                                    "We're sorry",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: logoColor,
                                                      fontSize: ScreenUtil()
                                                          .setSp(17.5),
                                                    ),
                                                  ),
                                                  OurSizedBox(),
                                                  Text(
                                                    "You have not sent any messages",
                                                    style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: ScreenUtil()
                                                          .setSp(15),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                            ],
                          );
                        }
                        return Container();
                      }
                    },
                  ),
                ),
                OurSizedBox(),
                OurSizedBox(),
              ],
            ),
          )),
        ));
  }
}
