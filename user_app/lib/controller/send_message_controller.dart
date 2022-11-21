import 'package:get/get.dart';

class MessageSendController extends GetxController {
  var sendMessage = true.obs;

  void initializeController() {
    sendMessage.value = true;
  }

  void toggle(bool values) {
    sendMessage.value = values;
  }
}
