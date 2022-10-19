import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';
import '../controller/polyline_controller.dart';
import '../models/lat_long_controller.dart';
import '../models/user_model.dart';
import '../screens/dashboard_screen/shopping_shop_profile_screen.dart';
import '../utils/color.dart';
import 'our_sized_box.dart';

class OurCustomInFo extends StatefulWidget {
  final double distance;
  final String uid;
  final String shopName;
  final String image;
  final CustomInfoWindowController controller;
  final QueryDocumentSnapshot<Map<String, dynamic>> element;
  const OurCustomInFo(
      {Key? key,
      required this.distance,
      required this.element,
      required this.controller,
      required this.image,
      required this.shopName,
      required this.uid})
      : super(key: key);

  @override
  State<OurCustomInFo> createState() => _OurCustomInFoState();
}

class _OurCustomInFoState extends State<OurCustomInFo> {
  List<LatLng> polylineCoordinates = [];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setSp(1000),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ScreenUtil().setSp(17.5),
        ),
      ),
      child: FlipCard(
        fill: Fill
            .fillBack, // Fill the back side of the card to make in the same size as the front.
        direction: FlipDirection.HORIZONTAL, // default
        front: Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              ScreenUtil().setSp(17.5),
            ),
            child: Image.network(
              widget.image,
              width: double.infinity,
              // width: MediaQuery.of(context).size.width * 0.65,
              height: ScreenUtil().setSp(100),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        back: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: ScreenUtil().setSp(65),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    ScreenUtil().setSp(17.5),
                  ),
                  topLeft: Radius.circular(
                    ScreenUtil().setSp(17.5),
                  ),
                ),
                child: Image.network(
                  widget.image,
                  width: double.infinity,
                  // width: MediaQuery.of(context).size.width * 0.65,
                  height: ScreenUtil().setSp(100),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // OurSizedBox(),
            SizedBox(
              height: ScreenUtil().setSp(2),
            ),
            Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setSp(2.5),
                right: ScreenUtil().setSp(5),
                left: ScreenUtil().setSp(5),
              ),
              child: Text(
                widget.shopName,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(17.5),
                  color: logoColor,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Divider(
            //   color: darklogoColor,
            // ),
            Container(
              // height: ScreenUtil().setSp(25),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        var uid = Uuid().v4();
                        List<Polyline> ourlist = [];
                        PolylineResult result;
                        Get.find<PolyLineController>().initialize();
                        Get.find<PolyLineController>().polylineList.clear();
                        print("Search My direction HEHEHAHAH");
                        PolylinePoints polylinePoints = PolylinePoints();

                        result =
                            await polylinePoints.getRouteBetweenCoordinates(
                          "AIzaSyBlMkiLJ-G7YNmFabacXbMwfI2dectJSfs",
                          PointLatLng(
                            Get.find<LatLongController>().lat.value,
                            Get.find<LatLongController>().long.value,
                          ),
                          PointLatLng(
                            widget.element.data()["latitude"],
                            widget.element.data()["longitude"],
                          ),
                        );
                        result.points.forEach((point) {
                          // print(element);
                          polylineCoordinates.add(
                            LatLng(
                              point.latitude,
                              point.longitude,
                            ),
                          );
                          PolylineId id = PolylineId(
                            "$uid $index",
                          );
                          Polyline polyline = Polyline(
                            polylineId: id,
                            color: darklogoColor.withOpacity(0.75),
                            points: polylineCoordinates,
                            width: 5,
                          );
                          ourlist.add(polyline);
                        });
                        Get.find<PolyLineController>().addPolyline(ourlist);
                        widget.controller.hideInfoWindow!();
                        print(result.points);
                        index++;
                        setState(() {});
                      },
                      child: Icon(
                        Icons.directions,
                        size: ScreenUtil().setSp(25),
                        color: logoColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setSp(5),
                  ),
                  Expanded(
                    child: InkWell(
                      // onTap: () {
                      //   print("HELLO WORLD");
                      //   print(Get.find<PolyLineController>().polylineList);
                      // },
                      onTap: () async {
                        DocumentSnapshot abc = await FirebaseFirestore.instance
                            .collection("Sellers")
                            .doc(widget.uid)
                            .get();
                        UserModel userModel = UserModel.fromMap(abc);
                        Navigator.push(
                          context,
                          PageTransition(
                            child: ShoppingShopProfileScreen(
                              userModel: userModel,
                              shopName: widget.shopName,
                              shopOwnerUID: widget.uid,
                            ),
                            type: PageTransitionType.leftToRight,
                          ),
                        );
                        // print("Button Pressed");
                      },
                      child: Icon(
                        Icons.person,
                        size: ScreenUtil().setSp(25),
                        color: logoColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // OurSizedBox(),
            Container(
              margin: EdgeInsets.only(
                left: ScreenUtil().setSp(3.5),
                top: ScreenUtil().setSp(2),
                right: ScreenUtil().setSp(3.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${widget.distance.round().toString()} meters away.",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(15),
                      color: logoColor,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
