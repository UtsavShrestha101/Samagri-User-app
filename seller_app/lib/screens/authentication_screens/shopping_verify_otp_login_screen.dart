import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/controller/otp_controller.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_flutter_toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../controller/login_controller.dart';
import '../../services/phone_auth/phone_auth.dart';
import '../../widget/our_elevated_button.dart';
import '../../widget/our_sized_box.dart';
import '../../widget/our_spinner.dart';

class VerifyOPTLoginScreen extends StatefulWidget {
  final String phoneNumber;
  const VerifyOPTLoginScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  State<VerifyOPTLoginScreen> createState() => _VerifyOPTLoginScreenState();
}

class _VerifyOPTLoginScreenState extends State<VerifyOPTLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  String? pin;
  String codeValue = "";

  // @override
  // void codeUpdated() {
  //   // print("Update code $code");
  //   setState(() {
  //     print("codeUpdated");
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<OTPController>().clearOTP;
    listenOtp();
  }

  void listenOtp() async {
    // await SmsAutoFill().unregisterListener();
    // listenForCode();
    await SmsAutoFill().listenForCode;
    print("OTP listen Called");
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    print("unregisterListener");
    super.dispose();
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(
        color: darklogoColor,
      ),
      borderRadius: BorderRadius.circular(
        ScreenUtil().setSp(5),
      ),
    );
  }

  void _showSnackBar(String pin, BuildContext context) {
    PhoneAuth().vertfyLoginPin(
      pin,
      context,
    );
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Lottie.asset(
                            "assets/animations/otp.json",
                            height: ScreenUtil().setSp(250),
                            width: ScreenUtil().setSp(250),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              "assets/images/otp_vector.png",
                              height: ScreenUtil().setSp(80),
                              width: ScreenUtil().setSp(80),
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(
                              width: ScreenUtil().setSp(10),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "OTP has been sent to your mobile number",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(15),
                                      color: logoColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  OurSizedBox(),
                                  Text(
                                    "${widget.phoneNumber}",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(17.5),
                                      color: darklogoColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const OurSizedBox(),
                        // PinPut(
                        //   eachFieldMargin: EdgeInsets.symmetric(
                        //     horizontal: ScreenUtil().setSp(5),
                        //   ),
                        //   fieldsAlignment: MainAxisAlignment.center,
                        //   eachFieldConstraints: BoxConstraints(
                        //     maxHeight: ScreenUtil().setSp(40),
                        //     maxWidth: ScreenUtil().setSp(40),
                        //   ),
                        // textStyle: TextStyle(
                        //   fontSize: ScreenUtil().setSp(15),
                        // ),
                        //   separator: SizedBox(
                        //     width: ScreenUtil().setSp(5),
                        //   ),
                        //   fieldsCount: 6,
                        //   onChanged: (String pins) {
                        //     setState(() {
                        //       pin = pins;
                        //     });
                        //   },
                        //   onSubmit: (String pin) {
                        //     _showSnackBar(pin, context);
                        //     FocusScope.of(context).unfocus();
                        //   },
                        //   validator: (value) {
                        //     if (value!.trim().isNotEmpty) {
                        //       return null;
                        //     } else {
                        //       return "Please fill otp";
                        //     }
                        //   },
                        //   focusNode: _pinPutFocusNode,
                        //   controller: _pinPutController,
                        //   submittedFieldDecoration: _pinPutDecoration,
                        //   selectedFieldDecoration: _pinPutDecoration,
                        //   followingFieldDecoration: _pinPutDecoration.copyWith(
                        //     borderRadius: BorderRadius.circular(
                        //       ScreenUtil().setSp(5),
                        //     ),
                        //     border: Border.all(
                        //       color: darklogoColor,
                        //     ),
                        //   ),
                        // ),
                        // const OurSizedBox(),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(30),
                          ),
                          child: PinFieldAutoFill(
                            decoration: CirclePinDecoration(
                              strokeWidth: 1,
                              gapSpace: ScreenUtil().setSp(10),
                              textStyle: TextStyle(
                                color: darklogoColor,
                                fontSize: ScreenUtil().setSp(17.5),
                              ),
                              strokeColorBuilder: FixedColorBuilder(
                                logoColor,
                              ),
                            ),
                            currentCode: Get.find<OTPController>().otp.value,
                            codeLength: 6,
                            onCodeChanged: (code) {
                              print("onCodeChanged $code");
                              Get.find<OTPController>()
                                  .changeOTP(code.toString());
                              // setState(() {
                              //   codeValue = code.toString();
                              // });
                            },
                            onCodeSubmitted: (val) {
                              print("onCodeSubmitted $val");
                            },
                          ),
                        ),
                        const OurSizedBox(),

                        Container(
                          height: ScreenUtil().setSp(40),
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(22.5),
                          ),
                          width: double.infinity,
                          child: OurElevatedButton(
                            title: "Login",
                            function: () async {
                              if (Get.find<OTPController>().otp.value.length !=
                                  6) {
                                print("==========");
                                print("==========");
                                print(Get.find<OTPController>().otp.value);
                                print("==========");
                                print("==========");

                                OurToast().showErrorToast("Please enter OTP");
                              } else {
                                _showSnackBar(
                                    Get.find<OTPController>().otp.value,
                                    context);
                              }
                              // if (_phone_number_controller.text.trim().isEmpty) {
                              //   OurToast().showErrorToast("Field can't be empty");
                              // } else {
                              //   Navigator.push(
                              //     context,
                              //     PageTransition(
                              //       type: PageTransitionType.leftToRight,
                              //       child: VerifyOPTLoginScreen(
                              //         phoneNumber: _phone_number_controller.text.trim(),
                              //       ),
                              //     ),
                              //   );
                              // }
                            },
                          ),
                        ),
                        // await Hive.box<int>(DatabaseHelper.outerlayerDB)
                        //     .put("state", 0);

                        OurSizedBox(),
                        Center(
                          child: FxButton.text(
                            onPressed: () {
                              Navigator.pop(context);
                              // MaterialPageRoute(
                              // builder: (context) => ShoppingRegisterScreen()));
                            },
                            child: FxText.b2(
                              "I have an account",
                              decoration: TextDecoration.underline,
                              fontSize: ScreenUtil().setSp(15),
                            ),
                          ),
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
