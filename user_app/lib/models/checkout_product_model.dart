// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CheckOutProductModel {
  final String ownerId;
  final String name;
  final int quantity;
  final double price;
  final String uid;
  final bool isPacked;

  CheckOutProductModel({
    required this.ownerId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.uid,
    required this.isPacked,
  });

  CheckOutProductModel copyWith({
    String? name,
    int? quantity,
    double? price,
    String? uid,
    bool? isPacked,
  }) {
    return CheckOutProductModel(
      ownerId: ownerId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      uid: uid ?? this.uid,
      isPacked: isPacked ?? this.isPacked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'quantity': quantity,
      'price': price,
      'uid': uid,
      'isPacked': isPacked,
      "ownerId": ownerId,
    };
  }

  factory CheckOutProductModel.fromMap(Map<String, dynamic> map) {
    return CheckOutProductModel(
      ownerId: map['ownerId'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
      uid: map['uid'] as String,
      isPacked: map['isPacked'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckOutProductModel.fromJson(String source) =>
      CheckOutProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CheckOutProductModel(name: $name, quantity: $quantity, price: $price, uid: $uid, isPacked: $isPacked)';
  }

  @override
  bool operator ==(covariant CheckOutProductModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.quantity == quantity &&
        other.price == price &&
        other.uid == uid &&
        other.isPacked == isPacked;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        quantity.hashCode ^
        price.hashCode ^
        uid.hashCode ^
        isPacked.hashCode;
  }
}
