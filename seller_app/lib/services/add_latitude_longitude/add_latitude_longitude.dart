import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  Future<List<Marker>?> getAllLocation(
      CustomInfoWindowController controller) async {
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
              icon: BitmapDescriptor.fromBytes(markerIcon),
              onTap: () {
                controller.addInfoWindow!(
                  Container(
                    // width: MediaQuery.of(context).size.width * 0.65,
                    // width: 400,
                    height: ScreenUtil().setSp(1000),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Image.asset(
                            "assets/images/banners/banner_1.jpg",
                            width: double.infinity,
                            // width: MediaQuery.of(context).size.width * 0.65,
                            height: ScreenUtil().setSp(100),
                            fit: BoxFit.cover,
                          ),
                        ),
                        OurSizedBox(),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(2.5),
                          ),
                          child: Text(
                            element.data()["uid"],
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(17.5),
                              color: logoColor,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Divider(
                          color: darklogoColor,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Icon(
                                Icons.directions,
                                size: ScreenUtil().setSp(25),
                                color: logoColor,
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setSp(5),
                            ),
                            Expanded(
                              child: Icon(
                                Icons.person,
                                size: ScreenUtil().setSp(25),
                                color: logoColor,
                              ),
                            ),
                          ],
                        ),
                        OurSizedBox(),
                      ],
                    ),
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
