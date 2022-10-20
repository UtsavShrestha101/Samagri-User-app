import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSellerModel {
  final int product;
  final int follower;
  final int following;
  final String uid;
  final String email;
  final String name;
  final String AddedOn;
  final String password;
  final String imageUrl;
  final String phone;
  final String location;
  final List followerList;
  final List followingList;

  FirebaseSellerModel({
    required this.product,
    required this.follower,
    required this.following,
    required this.followerList,
    required this.followingList,
    required this.uid,
    required this.email,
    required this.name,
    required this.AddedOn,
    required this.password,
    required this.imageUrl,
    required this.phone,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'AddedOn': AddedOn,
      'password': password,
      'imageUrl': imageUrl,
      'phone': phone,
      'Location': location,
    };
  }

  factory FirebaseSellerModel.fromMap(DocumentSnapshot map) {
    return FirebaseSellerModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      AddedOn: map['AddedOn'] ?? '',
      password: map['password'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      follower: map['follower'] ?? 0,
      followerList: map['followerList'] ?? [],
      following: map['following'] ?? 0,
      followingList: map['followingList'] ?? [],
      product: map['product'] ?? 0,
    );
  }
}
