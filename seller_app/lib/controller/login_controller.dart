
import 'package:get/get.dart';

class LoginController extends GetxController {
  var verId = "aa".obs;
  var processing = false.obs;
  var authpage = true.obs;
  // ignore: non_constant_identifier_names
  var phone_no = "".obs;
  void setVerId(String id) {
    verId = id.obs;
  }

   void setPhoneNo(String number) {
    phone_no.value = number;
  }

  void toggle(bool value) {
    processing.value = value;
  }

  void toggleAuthScreen(bool value) {
    authpage.value = value;
  }
}
