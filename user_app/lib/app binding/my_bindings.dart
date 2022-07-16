import 'package:get/get.dart';
import 'package:myapp/controller/login_controller.dart';
import 'package:myapp/controller/otp_controller.dart';
import 'package:myapp/controller/quantity_controller.dart';

import '../controller/address_choose_controller.dart';
import '../controller/dashboard_controller.dart';
import '../controller/delivery_time_controller.dart';
import '../controller/search_text_controller.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(
      () => LoginController(),
    );
    Get.lazyPut(
      () => DashboardController(),
    );
    Get.lazyPut(
      () => SearchTextController(),
    );
    Get.lazyPut(
      () => QuantityController(),
    );
    Get.lazyPut(
      () => ChooseAddressController(),
    );
    Get.lazyPut(
      () => DeliveryTimeController(),
    );
    Get.lazyPut(
      () => OTPController(),
    );
  }
}
