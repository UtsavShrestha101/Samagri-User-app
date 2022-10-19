import 'package:get/get.dart';

class LatLongController extends GetxController {
  var lat = 0.0.obs;
  var long = 0.0.obs;
  changeLocation(double latitude, double longitude) {
    lat.value = latitude;
    long.value = longitude;
  }
}
