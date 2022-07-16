import 'package:get/get.dart';

class ChooseAddressController extends GetxController {
  var choose = "".obs;
  void change(String value) {
    choose.value = value;
  }
}
