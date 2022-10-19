import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolyLineController extends GetxController {
  RxSet<Polyline> polylineList = <Polyline>{}.obs;

  initialize() {
    polylineList.value = {};
    polylineList.value.clear();
  }

  addPolyline(List<Polyline> polyline) {
    polylineList.value = {};

    polylineList.value.addAll(Set<Polyline>.of(polyline));
    print(polyline.length);
    print("HAHAHAHAHA  ADDED ADDED ADDED");
  }
}
