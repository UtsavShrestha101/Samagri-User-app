import 'package:get/get.dart';

class AddItemController extends GetxController {
  var item = "".obs;
  void changeText(String data) {
    item.value = data;
  }

  void initializeddd() {
    item.value = "";
  }
}
