import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUser11Model {
          final int product;
          final int follower;
        final int following;
        final String uid;
  final String name;
        final String AddedOn;
  final String imageUrl;
  final String phone;
  final List followerList;
  final List followingList;

  FirebaseUser11Model({
    required this.product,
    required this.follower,
    required this.following,
    required this.followerList,
    required this.followingList,
    required this.uid,
    required this.name,
    required this.AddedOn,
    required this.imageUrl,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'AddedOn': AddedOn,
      'imageUrl': imageUrl,
      'phone': phone,
    };
  }

  factory FirebaseUser11Model.fromMap(DocumentSnapshot map) {
    return FirebaseUser11Model(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      AddedOn: map['AddedOn'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      phone: map['phone'] ?? '',
      follower: map['follower'] ?? 0,
      followerList: map['followerList'] ?? [],
      following: map['following'] ?? 0,
      followingList: map['followingList'] ?? [],
      product: map['product'] ?? 0,
    );
  }
}
