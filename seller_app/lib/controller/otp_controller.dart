import 'package:get/get.dart';

class OTPController extends GetxController {
  var otp = "".obs;
  void clearOTP() {
    otp.value = "";
  }

  void changeOTP(String otpValue) {
    otp.value = otpValue;
  }
}
