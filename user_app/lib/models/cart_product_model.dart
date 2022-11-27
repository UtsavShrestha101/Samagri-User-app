import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CartProductModel {
  final String uid;
  final String ownerId;
  final String name;
  final String desc;
  final List url;
  final double price;
  final String shop;
  // "shop": product.shop_name,
  final Timestamp addedOn;
  final int quantity;

  CartProductModel({
    required this.ownerId,
    required this.shop,
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
      'shop': shop,
    };
  }

  factory CartProductModel.fromMap(DocumentSnapshot map) {
    return CartProductModel(
      ownerId: map['ownerId'] ?? '',
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      shop: map['shop'] ?? '',
      url: map['url'] ?? [],
      price: map['price']?.toDouble() ?? 0.0,
      addedOn: map['addedOn'],
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  factory CartProductModel.toIncreaseorDecrease(Map<String, dynamic> map) {
    return CartProductModel(
      shop: map['shop'] ?? '',
      ownerId: map['ownerId'] ?? '',
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      url: map['url'] ?? [],
      price: map['price']?.toDouble() ?? 0.0,
      addedOn: map['addedOn'],
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }
}
