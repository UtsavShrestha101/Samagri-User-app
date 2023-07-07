import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/controller/polyline_controller.dart';

import 'package:myapp/widget/our_custio_info_window.dart';
import 'package:myapp/widget/our_flutter_toast.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;

import '../../models/lat_long_controller.dart';
import '../../utils/color.dart';
import '../../widget/our_sized_box.dart';

class AddLatLongFirebase {
  addLatLong(double latitude, double longitude) async {
    print("Inside latitude and longitude service");
    try {
      var uid = Uuid().v4();

      //Location ->currentid ->[l]
      await FirebaseFirestore.instance.collection("Locations").doc(uid).set(
        {
          "uid": uid,
          "longitude": longitude,
          "latitude": latitude,
        },
      ).then((value) {
        OurToast().showSuccessToast(
          "Location added",
        );
      });
    } catch (e) {
      OurToast().showErrorToast(e.toString());
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<List<Marker>?> getAllLocation(CustomInfoWindowController controller,
      GoogleMapController gController) async {
    print("Inside Get All Location");
    List<Marker> markers = [];
    List<LatLng> polylineCoordinates = [];
    int index = 0;

    Get.find<PolyLineController>().initialize();
    try {
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/images/logo.png', 100);
      var aaa = await FirebaseFirestore.instance.collection("Locations").get();
      // print(aaa.docChanges.forEach((element) { }));
      aaa.docs.forEach((element) {
        print("Utsav");

        markers.add(
          Marker(
              markerId: MarkerId(element.data()["uid"]),
              position: LatLng(
                element.data()["latitude"],
                element.data()["longitude"],
              ),
              icon: BitmapDescriptor.fromBytes(markerIcon),
              onTap: () async {
                var distance = await Geolocator.distanceBetween(
                  Get.find<LatLongController>().lat.value,
                  Get.find<LatLongController>().long.value,
                  element.data()["latitude"],
                  element.data()["longitude"],
                );
                controller.addInfoWindow!(
                  OurCustomInFo(
                    uid: element.data()["uid"],
                    shopName: element.data()["name"],
                    image: element.data()["image"],
                    distance: distance,
                    element: element,
                    controller: controller,
                  ),
                  LatLng(
                    element.data()["latitude"],
                    element.data()["longitude"],
                  ),
                );
              }),
        );
      });
      return markers;
    } catch (e) {
      OurToast().showErrorToast(
        e.toString(),
      );
    }
  }
}
