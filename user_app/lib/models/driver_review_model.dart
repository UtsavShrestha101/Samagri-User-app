// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class DriverReviewModel {
  final String senderUID;
  final String driverUID;
  final String reviewUID;
  final String review;
  final String senderName;
  final Timestamp created_On;

  DriverReviewModel(
    this.senderUID,
    this.driverUID,
    this.reviewUID,
    this.review,
    this.senderName,
    this.created_On,
  );

  DriverReviewModel copyWith({
    String? senderUID,
    String? driverUID,
    String? reviewUID,
    String? review,
    String? senderName,
    Timestamp? created_On,
  }) {
    return DriverReviewModel(
      senderUID ?? this.senderUID,
      driverUID ?? this.driverUID,
      reviewUID ?? this.reviewUID,
      review ?? this.review,
      senderName ?? this.senderName,
      created_On ?? this.created_On,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderUID': senderUID,
      'driverUID': driverUID,
      'reviewUID': reviewUID,
      'review': review,
      'senderName': senderName,
      'created_On': created_On,
    };
  }

  factory DriverReviewModel.fromMap(DocumentSnapshot map) {
    return DriverReviewModel(
        map['senderUID'] as String,
        map['driverUID'] as String,
        map['reviewUID'] as String,
        map['review'] as String,
        map['senderName'] as String,
        map['created_On']);
  }

  String toJson() => json.encode(toMap());

  // factory DriverReviewModel.fromJson(String source) =>
  //     DriverReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DriverReviewModel(senderUID: $senderUID, driverUID: $driverUID, reviewUID: $reviewUID, review: $review, senderName: $senderName, created_On: $created_On)';
  }

  @override
  bool operator ==(covariant DriverReviewModel other) {
    if (identical(this, other)) return true;

    return other.senderUID == senderUID &&
        other.driverUID == driverUID &&
        other.reviewUID == reviewUID &&
        other.review == review &&
        other.senderName == senderName &&
        other.created_On == created_On;
  }

  @override
  int get hashCode {
    return senderUID.hashCode ^
        driverUID.hashCode ^
        reviewUID.hashCode ^
        review.hashCode ^
        senderName.hashCode ^
        created_On.hashCode;
  }
}
