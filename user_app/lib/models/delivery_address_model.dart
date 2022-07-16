import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryLocation {
  String? uid;
  String? administrativeArea;
  String? administrativeArea2;
  String? locality;
  String? sublocality;
  String? fullAddress;
  double? longitude;
  double? latitude;
  Timestamp? timestamp;

  DeliveryLocation(
      {this.uid,
      this.administrativeArea,
      this.administrativeArea2,
      this.locality,
      this.sublocality,
      this.fullAddress,
      this.longitude,
      this.latitude,
      this.timestamp});

  DeliveryLocation.fromJson(DocumentSnapshot json) {
    uid = json['uid'];
    administrativeArea = json['administrative_area'];
    administrativeArea2 = json['administrative_area2'];
    locality = json['locality'];
    sublocality = json['sublocality'];
    fullAddress = json['full_address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['administrative_area'] = this.administrativeArea;
    data['administrative_area2'] = this.administrativeArea2;
    data['locality'] = this.locality;
    data['sublocality'] = this.sublocality;
    data['full_address'] = this.fullAddress;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
