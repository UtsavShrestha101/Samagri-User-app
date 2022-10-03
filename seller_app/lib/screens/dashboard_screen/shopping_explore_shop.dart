import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/controller/explore_shop_controller.dart';
import 'package:myapp/controller/polyline_controller.dart';
import 'package:myapp/models/get_address_model.dart';
import 'package:myapp/models/lat_long_controller.dart';
import 'package:myapp/services/add_latitude_longitude/add_latitude_longitude.dart';
import 'package:myapp/services/firestore_service/location_detail.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_elevated_button.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:convert';
import 'package:custom_info_window/custom_info_window.dart';
import '../../controller/login_controller.dart';
import '../../models/address_result_model.dart';
import '../../widget/our_spinner.dart';

// import 'address_result.dart';
class ShopExploreScreen extends StatefulWidget {
  final Widget pinWidget;
  final String apiKey;
  // final LatLng initialLocation;
  final String appBarTitle;
  final String searchHint;
  final String addressTitle;
  final String confirmButtonText;
  final String language;
  final String country;
  final String addressPlaceHolder;
  final Color confirmButtonColor;
  final Color pinColor;
  final Color confirmButtonTextColor;
  const ShopExploreScreen({
    Key? key,
    required this.apiKey,
    required this.appBarTitle,
    required this.searchHint,
    required this.addressTitle,
    required this.confirmButtonText,
    required this.language,
    this.country = "",
    required this.confirmButtonColor,
    required this.pinColor,
    required this.confirmButtonTextColor,
    required this.addressPlaceHolder,
    required this.pinWidget,
    // required this.initialLocation,
  }) : super(key: key);
  @override
  State<ShopExploreScreen> createState() => ShopExploreScreenState();
}

class ShopExploreScreenState extends State<ShopExploreScreen>
    with TickerProviderStateMixin {
  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  final Completer<GoogleMapController> _controller = Completer();
  bool loading = false;
  String _currentAddress = "";
  LatLng? _latLng;
  String _shortName = "";
  CameraPosition? _kGooglePlex;
  Set<Marker> markers = new Set(); //markers for google map
  static const LatLng showLocation = const LatLng(27.7089427, 85.3086209);

  late AnimationController animationControllerListPage;
  late Animation<double> logoAnimationList;
  late Animation<double> fadeAnimation;
  late AnimationController animationController;
  late Uint8List markerbitmap;
  @override
  void dispose() {
    animationController.dispose();
    animationControllerListPage.dispose();

    customInfoWindowController.dispose();
    super.dispose();
  }

  // Latitude: 27.7122836, Longitude: 85.3686384
  @override
  void initState() {
    super.initState();
    Get.find<PolyLineController>().initialize();
    Get.find<ExploreShopController>().initialize();
    // Get.find<LoginController>().toggle(true);
    _latLng = LatLng(Get.find<LatLongController>().lat.value,
        Get.find<LatLongController>().long.value);
    // _kGooglePlex = CameraPosition(
    //   target: LatLng(Get.find<LatLongController>().lat.value,
    //       Get.find<LatLongController>().long.value),
    //   zoom: 17,
    // );

    getmarkers();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animationControllerListPage = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );

    logoAnimationList = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
        parent: animationControllerListPage,
        curve: Curves.linear,
      ),
    );
    animationControllerListPage.repeat(reverse: true);
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );
    animationController.forward();
  }

  getmarkers() async {
    _controller.future.then((value) async {
      List<Marker>? locationData = await AddLatLongFirebase()
          .getAllLocation(customInfoWindowController, value);

      setState(() {
        markers = locationData!.toSet();
        markers.add(
          Marker(
              markerId: MarkerId(
                "Current location",
              ),
              position: LatLng(Get.find<LatLongController>().lat.value,
                  Get.find<LatLongController>().long.value),
              // infoWindow: InfoWindow(
              //   title: "Current Location",
              // ),
              onTap: () {
                customInfoWindowController.addInfoWindow!(
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
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
                            width: MediaQuery.of(context).size.width * 0.65,
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
                            "Utsav Shrestha Utsav Shrestha Utsav Shrestha Utsav Shrestha",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(17.5),
                              color: logoColor,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        OurSizedBox(),
                        OurElevatedButton(
                          title: "title",
                          function: () {
                            print("Cleared");
                            Get.find<PolyLineController>().initialize();
                            Get.find<PolyLineController>()
                                .polylineList
                                .value
                                .clear();
                          },
                        )
                      ],
                    ),
                  ),
                  LatLng(Get.find<LatLongController>().lat.value,
                      Get.find<LatLongController>().long.value),
                );
              }),
        );
      });
    });
  }

  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ModalProgressHUD(
        inAsyncCall: Get.find<LoginController>().processing.value,
        progressIndicator: OurSpinner(),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotationTransition(
                  turns: logoAnimationList,
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: ScreenUtil().setSp(23.5),
                    width: ScreenUtil().setSp(23.5),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setSp(7.5),
                ),
                Text(
                  "Explore Shops",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(25),
                    color: darklogoColor,
                  ),
                ),
              ],
            ),
            actions: [
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: darklogoColor,
                  size: ScreenUtil().setSp(27.5),
                ),
                // color: darklogoColor,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      _controller.future.then((value) {
                        DefaultAssetBundle.of(context)
                            .loadString("assets/mapTheme/normal_theme.json")
                            .then((string1) {
                          value.setMapStyle(string1);
                        });
                      });
                    },
                    child: Text(
                      "Normal Theme",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(17.5),
                        color: logoColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      _controller.future.then((value) {
                        DefaultAssetBundle.of(context)
                            .loadString("assets/mapTheme/retro_theme.json")
                            .then((string1) {
                          value.setMapStyle(string1);
                        });
                      });
                    },
                    child: Text(
                      "Retro Theme",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(17.5),
                        color: logoColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      _controller.future.then((value) {
                        DefaultAssetBundle.of(context)
                            .loadString("assets/mapTheme/aubergine_theme.json")
                            .then((string1) {
                          value.setMapStyle(string1);
                        });
                      });
                    },
                    child: Text(
                      "Aubergine Theme",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(17.5),
                        color: logoColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      _controller.future.then((value) {
                        DefaultAssetBundle.of(context)
                            .loadString("assets/mapTheme/night_theme.json")
                            .then((string1) {
                          value.setMapStyle(string1);
                        });
                      });
                    },
                    child: Text(
                      "Night Theme",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(17.5),
                        color: logoColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Stack(
            children: [
              GoogleMap(
                // mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(Get.find<LatLongController>().lat.value,
                      Get.find<LatLongController>().long.value),
                  zoom: Get.find<ExploreShopController>()
                      .zoomLevel
                      .value
                      .toDouble(),
                ),
                markers: markers,
                polylines: Get.find<PolyLineController>().polylineList.value,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: true,
                zoomGesturesEnabled: false,
                myLocationEnabled: true,
                onCameraMoveStarted: () {
                  setState(() {
                    loading = true;
                  });
                },

                onTap: (position) {
                  customInfoWindowController.hideInfoWindow!();
                },
                onCameraMove: (p) {
                  _latLng = LatLng(p.target.latitude, p.target.longitude);
                  // print(_latLng);
                  // print("Camera changed");
                  customInfoWindowController.onCameraMove!();
                },
                onCameraIdle: () async {},
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  customInfoWindowController.googleMapController = controller;
                },
              ),
              CustomInfoWindow(
                controller: customInfoWindowController,
                height: ScreenUtil().setSp(200),
                width: MediaQuery.of(context).size.width * 0.7,
                offset: ScreenUtil().setSp(50),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * 0.45,
                // bottom: 0,
                left: ScreenUtil().setSp(0),
                child: Container(
                  height: ScreenUtil().setSp(150),
                  child: SfSlider.vertical(
                    activeColor: darklogoColor.withOpacity(0.5),
                    inactiveColor: logoColor.withOpacity(0.25),
                    min: 0.0,
                    max: 40.0,
                    value: _value,
                    interval: 10,
                    stepSize: 10,
                    minorTicksPerInterval: 0,
                    onChanged: (dynamic value) {
                      // 13 14 15 16 17
                      // 40 30 20 10 00
                      if (value == 0.0) {
                        Get.find<ExploreShopController>().changeZoomLevel(17);
                      } else if (value == 10.0) {
                        Get.find<ExploreShopController>().changeZoomLevel(16);
                      } else if (value == 20.0) {
                        Get.find<ExploreShopController>().changeZoomLevel(15);
                      } else if (value == 30.0) {
                        Get.find<ExploreShopController>().changeZoomLevel(14);
                      } else if (value == 40.0) {
                        Get.find<ExploreShopController>().changeZoomLevel(13);
                      }
                      _controller.future.then((value) {
                        value.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: _latLng!,
                              zoom: Get.find<ExploreShopController>()
                                  .zoomLevel
                                  .value
                                  .toDouble(),
                            ),
                          ),
                        );
                      });
                      // print(_value);
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                ),
              ),
              OurElevatedButton(
                title: Get.find<PolyLineController>()
                    .polylineList
                    .value
                    .length
                    .toString(),
                function: () {
                  print(Get.find<PolyLineController>().polylineList);
                },
              ),
              // Center(
              //   child: Padding(
              //     padding: EdgeInsets.only(
              //       bottom: ScreenUtil().setSp(40),
              //     ),
              //     child: widget.pinWidget,
              //   ),
              // ),
              // Positioned(
              //   left: 0,
              //   bottom: 0,
              //   right: 0,
              //   child: OurElevatedButton(
              //     title: "Explore",
              //     function: () async {
              //       await AddLatLongFirebase().addLatLong(
              //         _latLng!.latitude,
              //         _latLng!.longitude,
              //       );
              //       // print(_latLng);
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
