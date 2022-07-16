import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String uid;
  final String name;
  final String desc;
  final double price;
  final int rating;
  final String addedOn;
  final String url;
  final Timestamp timestamp;
  final List ratingUID;
  final int ratingNo;
  final List searchfrom;
  final List favorite;

  ProductModel({
    required this.favorite,
    required this.searchfrom,
    required this.ratingNo,
    required this.uid,
    required this.name,
    required this.desc,
    required this.price,
    required this.rating,
    required this.addedOn,
    required this.url,
    required this.timestamp,
    required this.ratingUID,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'desc': desc,
      'price': price,
      'rating': rating,
      'addedOn': addedOn,
      'url': url,
      'timestamp': timestamp,
      'ratingUID': ratingUID,
      'ratingNo': ratingNo,
      'favorite': favorite,
    };
  }

  factory ProductModel.fromMap(DocumentSnapshot map) {
    return ProductModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      rating: map['rating']?.toInt() ?? 0,
      addedOn: map['addedOn'] ?? '',
      url: map['url'] ?? '',
      timestamp: map['timestamp'] ?? '',
      ratingUID: map['ratingUID'] ?? [],
      ratingNo: map['ratingNo'],
      searchfrom: map['searchfrom'] ?? [],
      favorite: map['favorite'] ?? [],
    );
  }
}
