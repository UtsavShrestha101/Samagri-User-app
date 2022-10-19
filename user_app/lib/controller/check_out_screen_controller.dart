import 'package:get/get.dart';

class CheckOutScreenController extends GetxController {
  var index = 0.obs;
  var addressIndex = 1000999.obs;
  var paymentIndex = 0.obs;
  var address = "".obs;
  var time = "".obs;

  initialize() {
    paymentIndex.value = 1000999;
    index.value = 0;
    addressIndex.value = 1000999;
    address.value = "";
    time.value = "";
  }

  changeIndex(int value) {
    index.value = value;
  }

  changeAddressIndex(int value) {
    addressIndex.value = value;
  }

  changepaymentIndex(int value) {
    paymentIndex.value = value;
  }

  changeAddress(String value) {
    address.value = value;
  }
}
