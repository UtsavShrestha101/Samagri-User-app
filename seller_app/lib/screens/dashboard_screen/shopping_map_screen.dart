import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/models/get_address_model.dart';
import 'package:myapp/services/firestore_service/location_detail.dart';
import 'package:myapp/utils/color.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:convert';

import '../../controller/login_controller.dart';
import '../../models/address_result_model.dart';
import '../../widget/our_spinner.dart';

// import 'address_result.dart';
class ShopMapScreen extends StatefulWidget {
  final Widget pinWidget;
  final String apiKey;
  final LatLng initialLocation;
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
  const ShopMapScreen(
      {Key? key,
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
      required this.initialLocation})
      : super(key: key);
  @override
  State<ShopMapScreen> createState() => ShopMapScreenState();
}

class ShopMapScreenState extends State<ShopMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  bool loading = false;
  String _currentAddress = "";
  LatLng? _latLng;
  String _shortName = "";
  CameraPosition? _kGooglePlex;

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

  @override
  void initState() {
    super.initState();
    _latLng = widget.initialLocation;
    _kGooglePlex = CameraPosition(
      target: widget.initialLocation,
      zoom: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ModalProgressHUD(
          inAsyncCall: Get.find<LoginController>().processing.value,
          progressIndicator: OurSpinner(),
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                ScreenUtil().setSp(45),
              ),
              child: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.3,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: logoColor,
                        size: ScreenUtil().setSp(20),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.appBarTitle,
                          style: TextStyle(
                            color: logoColor,
                            fontSize: ScreenUtil().setSp(17.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex!,
                  myLocationButtonEnabled: true,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  myLocationEnabled: true,
                  onCameraMoveStarted: () {
                    setState(() {
                      loading = true;
                    });
                  },
                  onCameraMove: (p) {
                    _latLng = LatLng(p.target.latitude, p.target.longitude);
                  },
                  onCameraIdle: () async {
                    await getAddress(_latLng);
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            ScreenUtil().setSp(20),
                          ),
                          topRight: Radius.circular(
                            ScreenUtil().setSp(20),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: ScreenUtil().setSp(5),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: ScreenUtil().setSp(5),
                                width: ScreenUtil().setSp(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    ScreenUtil().setSp(10),
                                  ),
                                  color: Colors.grey.withOpacity(0.6),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setSp(15),
                            ),
                            Text(
                              widget.addressTitle,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: ScreenUtil().setSp(16.5),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setSp(7.5),
                            ),
                            Text(
                              _shortName,
                              style: TextStyle(
                                color: darklogoColor,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(17.5),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setSp(7.5),
                            ),
                            Text(
                              _currentAddress == ""
                                  ? widget.addressPlaceHolder
                                  : _currentAddress,
                              style: TextStyle(
                                color: logoColor,
                                fontSize: ScreenUtil().setSp(13.5),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setSp(7.5),
                            ),
                            if (!loading)
                              GestureDetector(
                                onTap: () async {
                                  Get.find<LoginController>().toggle(true);

                                  await Location().AddLocation(_currentAddress,
                                      _latLng?.longitude, _latLng?.latitude);
                                  Get.find<LoginController>().toggle(false);
                                  Navigator.pop(context);

                                  // AddressResult addressResult = AddressResult(
                                  //     latlng: _latLng!, address: _currentAddress);
                                  // Navigator.pop(context, addressResult);
                                },
                                child: SizedBox(
                                  height: ScreenUtil().setSp(50),
                                  child: Card(
                                    color: widget.confirmButtonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          ScreenUtil().setSp(7.5),
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.confirmButtonText,
                                        style: TextStyle(
                                          color: widget.confirmButtonTextColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: ScreenUtil().setSp(17.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: ScreenUtil().setSp(12.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () async {
                      // searchPlace();
                      var result = await Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => SearchPage(
                            language: widget.language,
                            apiKey: widget.apiKey,
                            searchPlaceHolder: widget.searchHint,
                          ),
                        ),
                      );
                      if (result != null) {
                        final location = await getPlace(result);
                        CameraPosition cPosition = CameraPosition(
                          zoom: 15,
                          target: LatLng(
                              double.parse(location['lat'].toString()),
                              double.parse(location['lng'].toString())),
                        );
                        final GoogleMapController controller =
                            await _controller.future;
                        controller
                            .animateCamera(
                                CameraUpdate.newCameraPosition(cPosition))
                            .then((value) {});
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          color: Colors.white,
                          child: IconButton(
                            onPressed: () async {
                              CameraPosition cPosition = CameraPosition(
                                zoom: 15,
                                target: widget.initialLocation,
                              );
                              final GoogleMapController controller =
                                  await _controller.future;
                              controller
                                  .animateCamera(
                                      CameraUpdate.newCameraPosition(cPosition))
                                  .then((value) {});
                            },
                            icon: Icon(
                              Icons.my_location,
                              color: logoColor,
                            ),
                            iconSize: ScreenUtil().setSp(25),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              ScreenUtil().setSp(90),
                          height: ScreenUtil().setSp(80),
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(20),
                            vertical: ScreenUtil().setSp(12),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  ScreenUtil().setSp(7.5),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setSp(10),
                                  horizontal: ScreenUtil().setSp(20)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: logoColor,
                                    size: ScreenUtil().setSp(22.5),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setSp(10),
                                  ),
                                  Text(
                                    widget.searchHint,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenUtil().setSp(16.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil().setSp(40),
                    ),
                    child: widget.pinWidget,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  getPlace(placeId) async {
    String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
    String request =
        '$baseURL?place_id=$placeId&key=${widget.apiKey}&language=${widget.language}';
    try {
      var response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        print("===================");
        print("===================");
        print("===================");
        print("===================");
        print("===================");
        print(request);
        print(res);
        print("===================");
        print("===================");
        print("===================");
        print("===================");
        print("===================");

        return res['result']['geometry']['location'];
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print("++++++++++++++");
      print(e);
      print("++++++++++++++");
    }
  }
}

class SearchPage extends StatefulWidget {
  final String language;
  final String apiKey;
  final String searchPlaceHolder;
  const SearchPage(
      {Key? key,
      required this.language,
      required this.apiKey,
      required this.searchPlaceHolder})
      : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  var uuid = new Uuid();
  var _sessionToken;
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=${widget.apiKey}&sessiontoken=$_sessionToken&language=en&components=country:np';
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print("++++++++++++++");
      print("++++++++++++++");

      print(e);
      print("++++++++++++++");
      print("++++++++++++++");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().setSp(40),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(10),
                vertical: ScreenUtil().setSp(10),
              ),
              child: Card(
                color: Colors.white.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setSp(7.5)))),
                child: Wrap(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(7.5)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: ScreenUtil().setSp(25),
                              )),
                          SizedBox(
                            width: ScreenUtil().setSp(15),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: widget.searchPlaceHolder,
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: ScreenUtil().setSp(16.5),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _placeList.length,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, _placeList[i]["place_id"]);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: ScreenUtil().setSp(10),
                            ),
                            Icon(
                              Icons.location_pin,
                              size: ScreenUtil().setSp(20),
                              color: darklogoColor,
                            ),
                            SizedBox(
                              width: ScreenUtil().setSp(10),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setSp(4.5),
                              ),
                              child: Container(
                                  width: MediaQuery.of(context).size.width -
                                      ScreenUtil().setSp(50),
                                  child: Text(
                                    _placeList[i]["description"],
                                    // "Utsav",
                                    // overflow: TextOverflow.ellipsis,
                                  )),
                            ),
                          ],
                        ),
                        const Divider()
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

showGoogleMapLocationPicker(
    {required BuildContext context,
    required Widget pinWidget,
    required String apiKey,
    required String appBarTitle,
    required String searchHint,
    required String addressTitle,
    required LatLng initialLocation,
    required String confirmButtonText,
    required String language,
    required String country,
    required String addressPlaceHolder,
    required Color confirmButtonColor,
    required Color pinColor,
    required Color confirmButtonTextColor}) async {
  final pickedLocation = await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => ShopMapScreen(
              apiKey: apiKey,
              pinWidget: pinWidget,
              appBarTitle: appBarTitle,
              searchHint: searchHint,
              addressTitle: addressTitle,
              confirmButtonText: confirmButtonText,
              language: language,
              confirmButtonColor: confirmButtonColor,
              pinColor: pinColor,
              confirmButtonTextColor: confirmButtonTextColor,
              addressPlaceHolder: addressPlaceHolder,
              initialLocation: initialLocation,
            )),
  );
  return pickedLocation;
}
