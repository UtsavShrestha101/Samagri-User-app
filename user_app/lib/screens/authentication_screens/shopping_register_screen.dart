import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/controller/login_controller.dart';
import 'package:myapp/screens/authentication_screens/shopping_verify_otp_sigup_screen.dart';
import 'package:myapp/services/phone_auth/phone_auth.dart';
import 'package:myapp/widget/our_elevated_button.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/color.dart';
import '../../widget/our_flutter_toast.dart';
import '../../widget/our_spinner.dart';
import 'shopping_login_screen.dart';

class ShoppingRegisterScreen extends StatefulWidget {
  @override
  _ShoppingRegisterScreenState createState() => _ShoppingRegisterScreenState();
}

class _ShoppingRegisterScreenState extends State<ShoppingRegisterScreen> {
  TextEditingController _user_name_controller = TextEditingController();
  TextEditingController _phone_number_controller = TextEditingController();
  FocusNode _user_name_node = FocusNode();
  FocusNode _phone_number_node = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Obx(() => ModalProgressHUD(
          inAsyncCall: Get.find<LoginController>().processing.value,
          progressIndicator: OurSpinner(),
          child: GestureDetector(
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
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.contain,
                        height: ScreenUtil().setSp(200),
                        width: ScreenUtil().setSp(200),
                      ),
                      OurSizedBox(),
                      Text(
                        "Create an Account",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(27.5),
                          color: darklogoColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      OurSizedBox(),
                      OurSizedBox(),
                      OurSizedBox(),
                      Container(
                        color: Colors.white70,
                        margin: EdgeInsets.only(
                          left: ScreenUtil().setSp(22.5),
                          right: ScreenUtil().setSp(22.5),
                          // top: ScreenUtil().setSp(30),
                        ),
                        child: FxContainer.none(
                          borderRadiusAll: 4,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                focusNode: _user_name_node,
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(_phone_number_node);
                                },
                                controller: _user_name_controller,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                  color: logoColor,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Colors.white70,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: logoColor,
                                    fontSize: ScreenUtil().setSp(
                                      17.5,
                                    ),
                                  ),
                                  hintText: "Username",
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                                autofocus: false,
                                keyboardType: TextInputType.name,
                                textCapitalization:
                                    TextCapitalization.sentences,
                              ),
                              Divider(
                                height: 0.5,
                              ),
                              TextFormField(
                                focusNode: _phone_number_node,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                controller: _phone_number_controller,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                  color: logoColor,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Colors.white70,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: logoColor,
                                    fontSize: ScreenUtil().setSp(
                                      17.5,
                                    ),
                                  ),
                                  hintText: "Phone number",
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                                autofocus: false,
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                        ),
                      ),
                      OurSizedBox(),
                      Container(
                        height: ScreenUtil().setSp(40),
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(22.5),
                        ),
                        width: double.infinity,
                        child: OurElevatedButton(
                          title: "Continue",
                          function: () async {
                            if (_user_name_controller.text.trim().isEmpty ||
                                _phone_number_controller.text.trim().isEmpty) {
                              OurToast().showErrorToast("Field can't be empty");
                            } else {
                              await PhoneAuth().sendSignUpOTP(
                                  _phone_number_controller.text.trim(),
                                  _user_name_controller.text.trim(),
                                  context);
                            }
                          },
                        ),
                      ),
                      // Container(
                      //     margin: EdgeInsets.only(left: 24, right: 24, top: 36),
                      //     child: FxButton.block(
                      //       borderRadiusAll: 4,
                      //       padding: FxSpacing.y(12),
                      //       elevation: 0,
                      //       onPressed: () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => ShoppingFullApp()));
                      //       },
                      //       child: FxText.b2("CONTINUE",
                      //           letterSpacing: 0.8, fontWeight: 700),
                      //     )),
                      OurSizedBox(),

                      Center(
                        child: FxButton.text(
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ShoppingLoginScreen()));
                          },
                          child: FxText.b2(
                            "I have an account",
                            decoration: TextDecoration.underline,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ),
        ));
  }
}
