import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/notification_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../utils/color.dart';
import '../../widget/our_sized_box.dart';
import '../../widget/our_spinner.dart';

class ShoppingNotificationScreen extends StatefulWidget {
  const ShoppingNotificationScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingNotificationScreen> createState() =>
      _ShoppingNotificationScreenState();
}

class _ShoppingNotificationScreenState extends State<ShoppingNotificationScreen>
    with TickerProviderStateMixin {
  late AnimationController animationControllerListPage;
  late Animation<double> logoAnimationList;
  late Animation<double> fadeAnimation;
  late AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animationControllerListPage = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );

    logoAnimationList = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
        parent: animationControllerListPage,
        curve: Curves.linear,
      ),
    );
    animationControllerListPage.repeat(reverse: true);
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    animationControllerListPage.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(10),
              vertical: ScreenUtil().setSp(10),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RotationTransition(
                        turns: logoAnimationList,
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: ScreenUtil().setSp(23.5),
                          width: ScreenUtil().setSp(23.5),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(7.5),
                      ),
                      Text(
                        "My Notifications",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(25),
                          color: darklogoColor,
                        ),
                      ),
                    ],
                  ),
                ),
                OurSizedBox(),
                Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Notifications")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("MyNotifications")
                            .orderBy("addedOn", descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: const OurSpinner(),
                            );
                          } else if (snapshot.hasData) {
                            if (snapshot.data!.docs.length > 0) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          NotificationModel notificationModel =
                                              NotificationModel.fromMap(
                                                  snapshot.data!.docs[index]);
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                              vertical: ScreenUtil().setSp(5),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: ScreenUtil().setSp(5),
                                              vertical: ScreenUtil().setSp(5),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                ScreenUtil().setSp(10),
                                              ),
                                            ),
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                notificationModel
                                                            .productImage !=
                                                        "abcd"
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                        child:
                                                            // Image.network(
                                                            //   widget.cartProductModel.url[0],
                                                            //   height: ScreenUtil().setSp(90),
                                                            //   fit: BoxFit.fill,
                                                            // ),
                                                            CachedNetworkImage(
                                                          height: ScreenUtil()
                                                              .setSp(90),
                                                          fit: BoxFit.fill,
                                                          imageUrl:
                                                              notificationModel
                                                                  .productImage,
                                                          placeholder:
                                                              (context, url) =>
                                                                  Image.asset(
                                                            "assets/images/placeholder.png",
                                                            height: ScreenUtil()
                                                                .setSp(90),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                SizedBox(
                                                  width: ScreenUtil().setSp(10),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        notificationModel
                                                            .senderName,
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(17.5),
                                                          color: darklogoColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      OurSizedBox(),
                                                      Text(
                                                        notificationModel
                                                                    .productImage !=
                                                                "abcd"
                                                            ? "${notificationModel.productName} is packed"
                                                            : notificationModel
                                                                .desc,
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(15),
                                                          color: darklogoColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      OurSizedBox(),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          timeago
                                                              .format(
                                                                  notificationModel
                                                                      .addedOn
                                                                      .toDate())
                                                              .toString(),
                                                          // notificationModel
                                                          //     .addedOn
                                                          //     .toDate()
                                                          //     .toString()
                                                          //     .split(" ")[0],
                                                          style: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(
                                                                        12.5),
                                                            color:
                                                                darklogoColor,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                  ],
                                ),
                              );
                            }
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/logo.png",
                                    fit: BoxFit.contain,
                                    height: ScreenUtil().setSp(150),
                                    width: ScreenUtil().setSp(150),
                                  ),
                                  OurSizedBox(),
                                  Text(
                                    "We're sorry",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: logoColor,
                                      fontSize: ScreenUtil().setSp(17.5),
                                    ),
                                  ),
                                  OurSizedBox(),
                                  Text(
                                    "You have no notifications",
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: ScreenUtil().setSp(15),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.contain,
                                  height: ScreenUtil().setSp(150),
                                  width: ScreenUtil().setSp(150),
                                ),
                                OurSizedBox(),
                                Text(
                                  "We're sorry",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: logoColor,
                                    fontSize: ScreenUtil().setSp(17.5),
                                  ),
                                ),
                                OurSizedBox(),
                                Text(
                                  "You have no notifications",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: ScreenUtil().setSp(15),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
