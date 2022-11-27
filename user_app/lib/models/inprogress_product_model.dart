// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class InProgressProductModel {
  final String ownerId;
  final String status;
  final String userPhoneNo;
  final String uid;
  final bool isDelivered;
  final String driverUid;
  final String driverName;
  final int verifyToken;
  final double totalPrice;
  final String paymentType;
  final String deliveryTime;
  final String deliveryAddress;
  final double lat;
  final double long;
  final List<dynamic> items;
  final Timestamp orderedAt;
  final Timestamp deliveredAt;

  InProgressProductModel(
    this.ownerId,
    this.status,
    this.userPhoneNo,
    this.uid,
    this.isDelivered,
    this.driverUid,
    this.driverName,
    this.verifyToken,
    this.totalPrice,
    this.paymentType,
    this.deliveryTime,
    this.deliveryAddress,
    this.lat,
    this.long,
    this.items,
    this.orderedAt,
    this.deliveredAt,
  );

  InProgressProductModel copyWith({
    String? ownerId,
    String? status,
    String? userPhoneNo,
    String? uid,
    bool? isDelivered,
    String? driverUid,
    String? driverName,
    int? verifyToken,
    double? totalPrice,
    String? paymentType,
    String? deliveryTime,
    String? deliveryAddress,
    double? lat,
    double? long,
    List<dynamic>? items,
    Timestamp? orderedAt,
    Timestamp? deliveredAt,
  }) {
    return InProgressProductModel(
      ownerId ?? this.ownerId,
      status ?? this.status,
      userPhoneNo ?? this.userPhoneNo,
      uid ?? this.uid,
      isDelivered ?? this.isDelivered,
      driverUid ?? this.driverUid,
      driverName ?? this.driverName,
      verifyToken ?? this.verifyToken,
      totalPrice ?? this.totalPrice,
      paymentType ?? this.paymentType,
      deliveryTime ?? this.deliveryTime,
      deliveryAddress ?? this.deliveryAddress,
      lat ?? this.lat,
      long ?? this.long,
      items ?? this.items,
      orderedAt ?? this.orderedAt,
      deliveredAt ?? this.deliveredAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ownerId': ownerId,
      'status': status,
      'userPhoneNo': userPhoneNo,
      'uid': uid,
      'isDelivered': isDelivered,
      'driverUid': driverUid,
      'driverName': driverName,
      'verifyToken': verifyToken,
      'totalPrice': totalPrice,
      'paymentType': paymentType,
      'deliveryTime': deliveryTime,
      'deliveryAddress': deliveryAddress,
      'lat': lat,
      'long': long,
      'items': items,
      'orderedAt': orderedAt,
      'deliveredAt': deliveredAt,
    };
  }

  factory InProgressProductModel.fromMap(Map<String, dynamic> map) {
    return InProgressProductModel(
      map['ownerId'] as String,
      map['status'] as String,
      map['userPhoneNo'] as String,
      map['uid'] as String,
      map['isDelivered'] as bool,
      map['driverUid'] as String,
      map['driverName'] as String,
      map['verifyToken'] as int,
      map['totalPrice'] as double,
      map['paymentType'] as String,
      map['deliveryTime'] as String,
      map['deliveryAddress'] as String,
      map['lat'] as double,
      map['long'] as double,
      map['items'] as List<dynamic>,
      map['orderedAt'] as Timestamp,
      map['deliveredAt'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory InProgressProductModel.fromJson(String source) =>
      InProgressProductModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InProgressProductModel(ownerId: $ownerId, status: $status, userPhoneNo: $userPhoneNo, uid: $uid, isDelivered: $isDelivered, driverUid: $driverUid, driverName: $driverName, verifyToken: $verifyToken, totalPrice: $totalPrice, paymentType: $paymentType, deliveryTime: $deliveryTime, deliveryAddress: $deliveryAddress, lat: $lat, long: $long, items: $items, orderedAt: $orderedAt, deliveredAt: $deliveredAt)';
  }

  @override
  bool operator ==(covariant InProgressProductModel other) {
    if (identical(this, other)) return true;

    return other.ownerId == ownerId &&
        other.status == status &&
        other.userPhoneNo == userPhoneNo &&
        other.uid == uid &&
        other.isDelivered == isDelivered &&
        other.driverUid == driverUid &&
        other.driverName == driverName &&
        other.verifyToken == verifyToken &&
        other.totalPrice == totalPrice &&
        other.paymentType == paymentType &&
        other.deliveryTime == deliveryTime &&
        other.deliveryAddress == deliveryAddress &&
        other.lat == lat &&
        other.long == long &&
        listEquals(other.items, items) &&
        other.orderedAt == orderedAt &&
        other.deliveredAt == deliveredAt;
  }

  @override
  int get hashCode {
    return ownerId.hashCode ^
        status.hashCode ^
        userPhoneNo.hashCode ^
        uid.hashCode ^
        isDelivered.hashCode ^
        driverUid.hashCode ^
        driverName.hashCode ^
        verifyToken.hashCode ^
        totalPrice.hashCode ^
        paymentType.hashCode ^
        deliveryTime.hashCode ^
        deliveryAddress.hashCode ^
        lat.hashCode ^
        long.hashCode ^
        items.hashCode ^
        orderedAt.hashCode ^
        deliveredAt.hashCode;
  }
}
