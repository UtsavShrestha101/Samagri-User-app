import 'package:app_settings/app_settings.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class GetCurrentLocation {
  Position? position;
  List<Placemark>? placeMarks;
  Future<Position?> getCurrentLocation() async {
    // Permission _permission = Permission.location;
    PermissionStatus _status = await Permission.location.request();

    if (_status.isPermanentlyDenied) {
      AppSettings.openAppSettings();
    }

    if (!_status.isGranted) {
      await Permission.location.request();
    } else {
      try {
        Position newPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        position = newPosition;
        return position;
        // placeMarks = await placemarkFromCoordinates(
        //   position!.latitude,
        //   position!.longitude,
        // );
        // Placemark pMark = placeMarks![1];
        // print(pMark);
        // String completeAddress =
        //     "${pMark.subLocality} ${pMark.locality} ${pMark.subAdministrativeArea} ${pMark.administrativeArea} ";
        // print(completeAddress);
        // return completeAddress;
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
