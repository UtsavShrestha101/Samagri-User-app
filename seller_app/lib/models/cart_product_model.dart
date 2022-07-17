import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CartProductModel {
  final String uid;
  final String name;
  final String desc;
  final String url;
  final double price;
  final Timestamp addedOn;
  final int quantity;

  CartProductModel({
    required this.uid,
    required this.name,
    required this.desc,
    required this.url,
    required this.price,
    required this.addedOn,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'dec': desc,
      'url': url,
      'price': price,
      'addedon': addedOn,
      'quantity': quantity,
    };
  }

  factory CartProductModel.fromMap(DocumentSnapshot map) {
    return CartProductModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      url: map['url'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      addedOn: map['addedOn'],
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

   factory CartProductModel.toIncreaseorDecrease(Map<String,dynamic> map) {
    return CartProductModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      url: map['url'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      addedOn: map['addedOn'],
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }
}
