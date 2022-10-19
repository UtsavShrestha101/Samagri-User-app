import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String uid;
  final String senderName;
  final String senderId;
  final String review;
  final Timestamp timestamp;

  ReviewModel({
    required this.uid,
    required this.senderName,
    required this.senderId,
    required this.review,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'senderName': senderName,
      'senderId': senderId,
      'review': review,
      'timestamp': timestamp
    };
  }

  factory ReviewModel.fromMap(DocumentSnapshot map) {
    return ReviewModel(
      uid: map['uid'] ?? '',
      senderName: map['senderName'] ?? '',
      senderId: map['senderId'] ?? '',
      review: map['review'] ?? '',
      timestamp: map['timestamp'] ?? "",
    );
  }
}
