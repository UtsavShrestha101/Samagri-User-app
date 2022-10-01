import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/widget/our_flutter_toast.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;

class AddLatLongFirebase {
  addLatLong(double latitude, double longitude) async {
    print("Inside latitude and longitude service");
    try {
      var uid = Uuid().v4();
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

  Future<List<Marker>?> getAllLocation() async {
    print("Inside Get All Location");
    List<Marker> markers = [];
    try {
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/images/logo.png', 100);
      var aaa = await FirebaseFirestore.instance.collection("Locations").get();
      // print(aaa.docChanges.forEach((element) { }));
      aaa.docs.forEach((element) {
        print("Utsav");

        element.data();
        markers.add(
          Marker(
            markerId: MarkerId(element.data()["uid"]),
            position: LatLng(
              element.data()["latitude"],
              element.data()["longitude"],
            ),
            infoWindow: InfoWindow(
              //popup info
              title: 'Our Second Location',
              // snippet: 'My Custom Subtitle',
            ),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ),
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
