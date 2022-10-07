import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryLocation {
  String? uid;

  String? fullAddress;
  double? longitude;
  double? latitude;
  Timestamp? timestamp;

  DeliveryLocation(
      {this.uid,
      this.fullAddress,
      this.longitude,
      this.latitude,
      this.timestamp});

  DeliveryLocation.fromJson(DocumentSnapshot json) {
    uid = json['uid'];

    fullAddress = json['full_address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;

    data['full_address'] = this.fullAddress;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
