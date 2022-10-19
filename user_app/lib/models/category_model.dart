import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CategoryModel {
  final String categoryName;
  final String image;

  CategoryModel({
    required this.categoryName,
    required this.image,
  });

  CategoryModel copyWith({
    String? categoryName,
    String? image,
  }) {
    return CategoryModel(
      categoryName: categoryName ?? this.categoryName,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryName': categoryName,
      'image': image,
    };
  }

  factory CategoryModel.fromMap(DocumentSnapshot map) {
    return CategoryModel(
      categoryName: map['categoryName'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'CategoryModel(categoryName: $categoryName, image: $image)';

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;

    return other.categoryName == categoryName && other.image == image;
  }

  @override
  int get hashCode => categoryName.hashCode ^ image.hashCode;
}
