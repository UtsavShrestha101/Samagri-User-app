import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String token;
  final String uid;
  final String imageUrl;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String location;
  final double lat;
  final double long;

  UserModel({
    required this.token,
    required this.uid,
    required this.imageUrl,
    required this.lat,
    required this.long,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.location,
  });

  UserModel copyWith({
    String? imageUrl,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? location,
    double? lat,
    double? long,
  }) {
    return UserModel(
      token: token,
      uid: uid,
      imageUrl: imageUrl ?? this.imageUrl,
      lat: lat ?? 0.0,
      long: long ?? 0.0,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "imageUrl": imageUrl,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'location': location,
      "lat": lat,
      "long": long,
    };
  }

  factory UserModel.fromMap(DocumentSnapshot map) {
    return UserModel(
      token: map["token"] ?? '',
      uid: map["uid"] ?? '',
      imageUrl: map["imageUrl"] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      lat: map['lat'] ?? '',
      long: map['long'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
