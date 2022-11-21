import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/utils/color.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controller/send_message_controller.dart';
import '../../models/message_model.dart';
import '../../services/message_service/chat_info_detail.dart';
import '../../services/message_service/chat_photo_storage.dart';
import '../../widget/our_sized_box.dart';
import '../../widget/our_text_field.dart';

class MessageSendScreen extends StatefulWidget {
  final UserModel userModel;
  const MessageSendScreen({Key? key, required this.userModel})
      : super(key: key);

  @override
  State<MessageSendScreen> createState() => _MessageSendScreenState();
}

class _MessageSendScreenState extends State<MessageSendScreen> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    Get.find<MessageSendController>().toggle(true);
  }

  File? file;

  pickImage() async {
    Permission _permission = Permission.storage;
    PermissionStatus _status = await _permission.request();

    if (!_status.isGranted) {
      await Permission.location.request();
    }
    if (_status.isPermanentlyDenied) {
      AppSettings.openAppSettings();
      print("=========================");
    }

    try {
      final ImagePicker _picker = ImagePicker();
      var result = await _picker.pickImage(source: ImageSource.gallery);
      ;

      if (result != null) {
        setState(() {});
        file = File(result.path);
        await ChatImageUpload().uploadImage(widget.userModel, file!);
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print("$e =========");
    }
  }

  final _messaging_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: darklogoColor,
                size: ScreenUtil().setSp(25),
              ),
            ),
            elevation: 0,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    ScreenUtil().setSp(30),
                  ),
                  child: Container(
                      color: Colors.white,
                      child: widget.userModel.imageUrl != ""
                          ? CachedNetworkImage(
                              imageUrl: widget.userModel.imageUrl,

                              // Image.network(
                              placeholder: (context, url) => Image.asset(
                                "assets/images/profile_holder.png",
                              ),
                              height: ScreenUtil().setSp(40),
                              width: ScreenUtil().setSp(40),
                              fit: BoxFit.cover,
                              //   )
                            )
                          : Container()),
                ),
                SizedBox(
                  width: ScreenUtil().setSp(10),
                ),
                Text(
                  widget.userModel.name,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(17.5),
                    color: darklogoColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          body: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(10),
              vertical: ScreenUtil().setSp(10),
            ),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("ChatRoom")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("Chat")
                        .doc(widget.userModel.uid)
                        .collection("Messages")
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.length > 0) {
                          SchedulerBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            messageController.jumpTo(
                                messageController.position.maxScrollExtent);
                          });
                          return ListView.builder(
                              controller: messageController,
                              // physics: NeverScrollableScrollPhysics(),
                              // shrinkWrap: true,
                              reverse: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                MessageModel messageModel =
                                    MessageModel.fromJson(
                                  snapshot.data!.docs[index],
                                );
                                return messageModel.type == "text"
                                    ? Row(
                                        mainAxisAlignment:
                                            messageModel.ownerId ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setSp(15),
                                              vertical: ScreenUtil().setSp(15),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: ScreenUtil().setSp(5),
                                              vertical: ScreenUtil().setSp(5),
                                            ),
                                            decoration: BoxDecoration(
                                              color: logoColor.withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                ScreenUtil().setSp(20),
                                              ),
                                            ),
                                            child: Text(
                                              messageModel.message,
                                              // style: SmallText,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            messageModel.ownerId ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                ScreenUtil().setSp(30),
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: ScreenUtil().setSp(5),
                                              vertical: ScreenUtil().setSp(5),
                                            ),
                                            child: CachedNetworkImage(
                                              width: 200,
                                              height: 200,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                "assets/images/placeholder.png",
                                                fit: BoxFit.cover,
                                              ),
                                              imageUrl: messageModel.message,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          )
                                        ],
                                      );
                              });
                        }
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
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        await pickImage();
                        // print("Imaged Clicked");
                      },
                      child: Icon(
                        Icons.image,
                        size: ScreenUtil().setSp(
                          30,
                        ),
                        color: logoColor,
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setSp(15),
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
                          // textAlign: TextAlign.center,
                          scrollPadding: EdgeInsets.only(
                            left: ScreenUtil().setSp(15),
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          cursorColor: Colors.white,
                          controller: _messaging_controller,
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
                            contentPadding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setSp(10),
                              horizontal: ScreenUtil().setSp(2),
                            ),
                            isDense: true,
                            hintText: "   Send Message",
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
                        if (_messaging_controller.text.trim().isNotEmpty) {
                          if (Get.find<MessageSendController>()
                              .sendMessage
                              .value) {
                            Get.find<MessageSendController>().toggle(false);
                            await ChatDetailFirebase().messageDetail(
                              _messaging_controller.text.trim(),
                              widget.userModel,
                            );
                            FocusScope.of(context).unfocus();
                            _messaging_controller.clear();
                            // Get.find<ProcessingController>().toggle(false);
                            Get.find<MessageSendController>().toggle(true);

                            print("Its not empty");
                          } else {}
                        } else {
                          print("Its empty");
                          FocusScope.of(context).unfocus();
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
                )
              ],
            ),
          ),
        ));
  }
}
