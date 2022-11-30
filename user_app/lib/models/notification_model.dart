// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String productName;
  final String productImage;
  final String senderName;
  final String desc;
  final Timestamp addedOn;

  NotificationModel(
    this.productName,
    this.productImage,
    this.senderName,
    this.desc,
    this.addedOn,
  );

  NotificationModel copyWith({
    String? productName,
    String? productImage,
    String? senderName,
    String? desc,
    Timestamp? addedOn,
  }) {
    return NotificationModel(
      productName ?? this.productName,
      productImage ?? this.productImage,
      senderName ?? this.senderName,
      desc ?? this.desc,
      addedOn ?? this.addedOn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productName': productName,
      'productImage': productImage,
      'senderName': senderName,
      'desc': desc,
      'addedOn': addedOn,
    };
  }

  factory NotificationModel.fromMap(DocumentSnapshot map) {
    return NotificationModel(
      map['productName'] as String,
      map['productImage'] as String,
      map['senderName'] as String,
      map['desc'] as String,
      map['addedOn'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  // factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(productName: $productName, productImage: $productImage, senderName: $senderName, desc: $desc, addedOn: $addedOn)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.productName == productName &&
        other.productImage == productImage &&
        other.senderName == senderName &&
        other.desc == desc &&
        other.addedOn == addedOn;
  }

  @override
  int get hashCode {
    return productName.hashCode ^
        productImage.hashCode ^
        senderName.hashCode ^
        desc.hashCode ^
        addedOn.hashCode;
  }
}
