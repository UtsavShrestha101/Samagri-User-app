import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:page_transition/page_transition.dart';

import '../models/messanger_home_model.dart';
import '../models/user_model.dart';
import '../models/user_model_firebase.dart';
import '../screens/dashboard_screen/shopping_chat_send_screen.dart';
import 'our_spinner.dart';

class OurSellerChat extends StatefulWidget {
  const OurSellerChat({Key? key}) : super(key: key);

  @override
  State<OurSellerChat> createState() => _OurSellerChatState();
}

class _OurSellerChatState extends State<OurSellerChat> {
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
                          .collection("Sellers")
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
                                  UserModel userModel = UserModel.fromMap(
                                      snapshot.data!.docs[index]);
                                  return InkWell(
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
                                          type: PageTransitionType.leftToRight,
                                          child: MessageSendScreen(
                                            firebaseUser11: userModel11,
                                            userModel: userModel,
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
                                          userModel.imageUrl != ""
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
                                                      imageUrl:
                                                          userModel.imageUrl,

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
                                                    userModel.name[0]
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
                                                userModel.name,
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
          return Column(
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
          );
        },
      ),
    );
  }
}
