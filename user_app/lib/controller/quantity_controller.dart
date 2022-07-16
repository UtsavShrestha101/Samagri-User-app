
import 'package:get/get.dart';

class QuantityController extends GetxController {
  var quantity = 1.obs;
  void changeQuantity(int value) {
    quantity.value = value;
  }
}
