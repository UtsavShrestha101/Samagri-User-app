import 'package:get/get.dart';

class DeliveryTimeController extends GetxController {
  var time = "".obs;
  void change(String value) {
    time.value = value;
  }
}
