import 'package:get/get.dart';

class DeliveryTimeController extends GetxController {
  var time = "".obs;
  var shippingTime = "".obs;
  initialize() {
    time.value = "";
    shippingTime.value = "";
  }

  void changeTime(String time) {
    shippingTime.value = time;
  }

  void change(String value) {
    time.value = value;
  }
}
