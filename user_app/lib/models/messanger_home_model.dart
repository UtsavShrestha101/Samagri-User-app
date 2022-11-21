import 'package:cloud_firestore/cloud_firestore.dart';

class MessangeHomeModel {
  final String uid;
  final Timestamp timestamp;

  MessangeHomeModel({
    required this.uid,
    required this.timestamp,
  });

  factory MessangeHomeModel.fromJson(DocumentSnapshot querySnapshot) {
    return MessangeHomeModel(
      uid: querySnapshot["uid"],
      timestamp: querySnapshot["timestamp"],
    );
  }
}
