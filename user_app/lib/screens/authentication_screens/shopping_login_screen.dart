/*
* File : Shopping Login
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/screens/authentication_screens/shopping_verify_otp_login_screen.dart';
import 'package:myapp/services/phone_auth/phone_auth.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_elevated_button.dart';
import 'package:myapp/widget/our_flutter_toast.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:myapp/widget/our_text_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../controller/login_controller.dart';
import '../../db/db_helper.dart';
import '../../widget/our_spinner.dart';
import 'shopping_register_screen.dart';

class ShoppingLoginScreen extends StatefulWidget {
  @override
  _ShoppingLoginScreenState createState() => _ShoppingLoginScreenState();
}

class _ShoppingLoginScreenState extends State<ShoppingLoginScreen> {
  TextEditingController _phone_number_controller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _phone_number_controller.clear();
    _phone_number_controller.dispose();
    super.dispose();
  }

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
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        OurSizedBox(),
                        Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.contain,
                          height: ScreenUtil().setSp(200),
                          width: ScreenUtil().setSp(200),
                        ),
                        OurSizedBox(),
                        Text(
                          "Go Mart: User",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(27.5),
                            color: darklogoColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        OurSizedBox(),
                        OurSizedBox(),
                        OurSizedBox(),
                        CustomTextField(
                            letterlength: 10,
                            controller: _phone_number_controller,
                            validator: (value) {},
                            title: "Enter your phone no.",
                            type: TextInputType.phone,
                            number: 1),
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
                              if (_phone_number_controller.text
                                  .trim()
                                  .isEmpty) {
                                OurToast()
                                    .showErrorToast("Field can't be empty");
                              } else {
                                var appSignatureID =
                                    await SmsAutoFill().getAppSignature;
                                print("==========");
                                print("==========");
                                print("==========");
                                print("==========");
                                print(appSignatureID);
                                print("==========");
                                print("==========");
                                print("==========");
                                print("==========");
                                await PhoneAuth().sendLoginOTP(
                                  _phone_number_controller.text.trim(),
                                  context,
                                );
                              }
                            },
                          ),
                        ),
                        OurSizedBox(),
                        Center(
                          child: FxButton.text(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: ShoppingRegisterScreen(),
                                ),
                              );
                              // MaterialPageRoute(
                              // builder: (context) => ShoppingRegisterScreen()));
                            },
                            child: FxText.b2(
                              "I don't have an account",
                              decoration: TextDecoration.underline,
                              fontSize: ScreenUtil().setSp(15),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
