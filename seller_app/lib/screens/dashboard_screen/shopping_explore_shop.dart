import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/models/get_address_model.dart';
import 'package:myapp/models/lat_long_controller.dart';
import 'package:myapp/services/add_latitude_longitude/add_latitude_longitude.dart';
import 'package:myapp/services/firestore_service/location_detail.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_elevated_button.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:convert';

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

class ShopExploreScreenState extends State<ShopExploreScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  bool loading = false;
  String _currentAddress = "";
  LatLng? _latLng;
  String _shortName = "";
  CameraPosition? _kGooglePlex;
  Set<Marker> markers = new Set(); //markers for google map
  static const LatLng showLocation = const LatLng(27.7089427, 85.3086209);

  getAddress(LatLng? location) async {
    try {
      final endpoint =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}'
          '&key=${widget.apiKey}&language=${widget.language}';

      final response = jsonDecode((await http.get(
        Uri.parse(endpoint),
      ))
          .body);
      getAddressModel getaddress = getAddressModel.fromJson(response);
      setState(() {
        _currentAddress =
            "${getaddress.results![0].addressComponents![1].longName!}, ${getaddress.results![0].addressComponents![2].longName!}, ${getaddress.results![0].addressComponents![3].longName!}, ${getaddress.results![0].addressComponents![4].longName!}, ${getaddress.results![0].addressComponents![5].longName!}";
        _shortName =
            response['results'][0]['address_components'][1]['long_name'];
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      loading = false;
    });
  }

  late Uint8List markerbitmap;

  // Latitude: 27.7122836, Longitude: 85.3686384

  @override
  void initState() {
    super.initState();
    // Get.find<LoginController>().toggle(true);
    _latLng = LatLng(Get.find<LatLongController>().lat.value,
        Get.find<LatLongController>().long.value);
    _kGooglePlex = CameraPosition(
      target: LatLng(Get.find<LatLongController>().lat.value,
          Get.find<LatLongController>().long.value),
      zoom: 15,
    );
    getmarkers();
    // Future.delayed(Duration(seconds: 3), () {
    //   Get.find<LoginController>().toggle(false);
    // });
    // setState(() {});
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

  getmarkers() async {
    List<Marker>? locationData = await AddLatLongFirebase().getAllLocation();
    setState(() {
      markers = locationData!.toSet();
      markers.add(
        Marker(
            markerId: MarkerId(
              "Current location",
            ),
            position: LatLng(Get.find<LatLongController>().lat.value,
                Get.find<LatLongController>().long.value),
            infoWindow: InfoWindow(
              title: "Current Location",
            )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ModalProgressHUD(
        inAsyncCall: Get.find<LoginController>().processing.value,
        progressIndicator: OurSpinner(),
        child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex!,
                markers: markers,
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
                onCameraMove: (p) {
                  _latLng = LatLng(p.target.latitude, p.target.longitude);
                },
                onCameraIdle: () async {},
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
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

  // getPlace(placeId) async {
  //   String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
  //   String request =
  //       '$baseURL?place_id=$placeId&key=${widget.apiKey}&language=${widget.language}';
  //   try {
  //     var response = await http.get(Uri.parse(request));

  //     if (response.statusCode == 200) {
  //       var res = json.decode(response.body);
  //       print("===================");
  //       print("===================");
  //       print("===================");
  //       print("===================");
  //       print("===================");
  //       print(request);
  //       print(res);
  //       print("===================");
  //       print("===================");
  //       print("===================");
  //       print("===================");
  //       print("===================");

  //       return res['result']['geometry']['location'];
  //     } else {
  //       throw Exception('Failed to load predictions');
  //     }
  //   } catch (e) {
  //     print("++++++++++++++");
  //     print(e);
  //     print("++++++++++++++");
  //   }
  // }
}
