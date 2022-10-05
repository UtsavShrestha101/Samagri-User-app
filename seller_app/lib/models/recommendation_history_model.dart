// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendationHistoryModel {
  final String productName;
  final String productUID;
  final Timestamp timestamp;

  RecommendationHistoryModel({
    required this.productName,
    required this.productUID,
    required this.timestamp,
  });

  RecommendationHistoryModel copyWith({
    String? productName,
    String? productUID,
    Timestamp? timestamp,
  }) {
    return RecommendationHistoryModel(
      productName: productName ?? this.productName,
      productUID: productUID ?? this.productUID,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productName': productName,
      'productUID': productUID,
      'timestamp': timestamp,
    };
  }

  factory RecommendationHistoryModel.fromMap(DocumentSnapshot map) {
    return RecommendationHistoryModel(
      productName: map['productName'] as String,
      productUID: map['productUID'] as String,
      timestamp: map['timestamp'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory RecommendationHistoryModel.fromJson(String source) =>
  //     RecommendationHistoryModel.fromMap(
  //         json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RecommendationHistoryModel(productName: $productName, productUID: $productUID, timestamp: $timestamp)';

  @override
  bool operator ==(covariant RecommendationHistoryModel other) {
    if (identical(this, other)) return true;

    return other.productName == productName &&
        other.productUID == productUID &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      productName.hashCode ^ productUID.hashCode ^ timestamp.hashCode;
}
