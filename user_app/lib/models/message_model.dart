import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final String type;
  final String ownerId;
  final String receivedId;
  final String imageUrl;
  final Timestamp timestamp;

  MessageModel({
    required this.message,
    required this.type,
    required this.ownerId,
    required this.receivedId,
    required this.imageUrl,
    required this.timestamp,
  });

  factory MessageModel.fromJson(DocumentSnapshot querySnapshot) {
    return MessageModel(
      message: querySnapshot["message"],
      type: querySnapshot["type"],
      ownerId: querySnapshot["ownerId"],
      receivedId: querySnapshot["receiverId"],
      imageUrl: querySnapshot["imageUrl"],
      timestamp: querySnapshot["timestamp"],
    );
  }
}
