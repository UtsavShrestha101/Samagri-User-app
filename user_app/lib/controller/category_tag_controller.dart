import 'package:get/get.dart';

class CategoryTagController extends GetxController {
  var tag = 0.obs;
  var name = "All".obs;

  initialize() {
    tag.value = 0;
    name.value = "All";
  }

  changeTag(int value, String itemName) {
    tag.value = value;
    name.value = itemName;
    print(value);
    print(itemName);
  }
}
