import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/driver_model.dart';
import 'package:myapp/models/user_model_firebase.dart';
import 'package:myapp/screens/dashboard_screen/shopping_driver_chat_screen.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:myapp/widget/our_spinner.dart';
import 'package:page_transition/page_transition.dart';

import '../models/messanger_home_model.dart';

class OurDriverChat extends StatefulWidget {
  const OurDriverChat({Key? key}) : super(key: key);

  @override
  State<OurDriverChat> createState() => _OurDriverChatState();
}

class _OurDriverChatState extends State<OurDriverChat> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ChatRoom")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Chat")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length > 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    //  return Text("data");

                    MessangeHomeModel messangeHomeModel =
                        MessangeHomeModel.fromJson(snapshot.data!.docs[index]);
                    // return Text(messangeHomeModel.uid);
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Drivers")
                          .where("uid", isEqualTo: messangeHomeModel.uid)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          // return Text("UTsav");
                          if (snapshot.data!.docs.length > 0) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DriverModel driverModel =
                                      DriverModel.fromDriverMap(
                                          snapshot.data!.docs[index]);
                                  return InkWell(
                                    onTap: () async {
                                      var a = await FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .get();
                                      FirebaseUser11Model userModel =
                                          FirebaseUser11Model.fromMap(a);
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.leftToRight,
                                          child: DriverMessageSendScreen(
                                            userModel: userModel,
                                            driverModel: driverModel,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setSp(10),
                                        vertical: ScreenUtil().setSp(10),
                                      ),
                                      child: Row(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          driverModel.profile_pic != ""
                                              ? CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius:
                                                      ScreenUtil().setSp(25),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      ScreenUtil().setSp(25),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl: driverModel
                                                          .profile_pic!,

                                                      // Image.network(
                                                      placeholder:
                                                          (context, url) =>
                                                              Image.asset(
                                                        "assets/images/profile_holder.png",
                                                        width: double.infinity,
                                                        height: ScreenUtil()
                                                            .setSp(125),
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        "assets/images/profile_holder.png",
                                                        width: double.infinity,
                                                        height: ScreenUtil()
                                                            .setSp(125),
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                      height: ScreenUtil()
                                                          .setSp(70),
                                                      width: ScreenUtil()
                                                          .setSp(70),
                                                      fit: BoxFit.cover,
                                                      //   )
                                                    ),
                                                  ))
                                              : CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius:
                                                      ScreenUtil().setSp(20),
                                                  child: Text(
                                                    driverModel.user_name![0]
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize:
                                                          ScreenUtil().setSp(
                                                        20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(
                                            width: ScreenUtil().setSp(20),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                driverModel.user_name!,
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(15),
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: ScreenUtil().setSp(4.5),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                          return Container();
                        }
                        return Container();
                      },
                    );
                  });
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return OurSpinner();
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
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
                    fontSize: ScreenUtil().setSp(17.5),
                  ),
                ),
                OurSizedBox(),
                Text(
                  "You have not sent any messages",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: ScreenUtil().setSp(15),
                  ),
                ),
                Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
