import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressResult{
  LatLng latlng;
  String address;

  AddressResult({required this.latlng, required this.address});
}