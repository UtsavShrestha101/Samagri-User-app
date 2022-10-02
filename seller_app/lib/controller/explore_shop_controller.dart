import 'package:get/get.dart';

class ExploreShopController extends GetxController {
  var zoomLevel = 17.obs;
  initialize() {
    zoomLevel.value = 17;
  }

  changeZoomLevel(int value) {
    zoomLevel.value = value;
    // print("Changed");
    // print("Changed value is $value");
  }
}
