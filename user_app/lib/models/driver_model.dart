// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DriverModel {
  final String? uid;
  final int? follower;
  final int? following;
  final int? reviews;
  final String? bio;
  final Timestamp? created_on;
  final String? profile_pic;
  final String? user_name;
  final String? email;
  final List? followerList;
  final List? reviewList;
  final List? followingList;
  final List? communityList;
  final int? delivered;
  final String? token;
  DriverModel({
    required this.uid,
    required this.follower,
    required this.following,
    required this.reviews,
    required this.bio,
    required this.created_on,
    required this.profile_pic,
    required this.user_name,
    required this.email,
    required this.followerList,
    required this.reviewList,
    required this.followingList,
    required this.communityList,
    required this.delivered,
    required this.token,
  });

  DriverModel copyWith({
    String? uid,
    int? follower,
    int? following,
    int? reviews,
    String? bio,
    Timestamp? created_on,
    String? profile_pic,
    String? user_name,
    String? email,
    List? followerList,
    List? reviewList,
    List? followingList,
    List? communityList,
    int? delivered,
    String? token,
  }) {
    return DriverModel(
      uid: uid ?? this.uid,
      follower: follower ?? this.follower,
      following: following ?? this.following,
      reviews: reviews ?? this.reviews,
      bio: bio ?? this.bio,
      created_on: created_on ?? this.created_on,
      profile_pic: profile_pic ?? this.profile_pic,
      user_name: user_name ?? this.user_name,
      email: email ?? this.email,
      followerList: followerList ?? this.followerList,
      reviewList: reviewList ?? this.reviewList,
      followingList: followingList ?? this.followingList,
      communityList: communityList ?? this.communityList,
      delivered: delivered ?? this.delivered,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'follower': follower,
      'following': following,
      'reviews': reviews,
      'bio': bio,
      'created_on': created_on,
      'profile_pic': profile_pic,
      'user_name': user_name,
      'email': email,
      'followerList': followerList,
      'reviewList': reviewList,
      'followingList': followingList,
      'communityList': communityList,
      'delivered': delivered,
      'token': token,
    };
  }

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      uid: map['uid'] as String,
      follower: map['follower'] as int,
      following: map['following'] as int,
      reviews: map['reviews'] as int,
      bio: map['bio'] as String,
      created_on: map['created_on'],
      profile_pic: map['profile_pic'] as String,
      user_name: map['user_name'] as String,
      email: map['email'] as String,
      followerList: map['followerList'],
      reviewList: map['reviewList'],
      followingList: map['followingList'],
      communityList: map['communityList'],
      delivered: map['delivered'] as int,
      token: map['token'] as String,
    );
  }
  factory DriverModel.fromDriverMap(DocumentSnapshot map) {
    return DriverModel(
      uid: map['uid'] ?? "",
      follower: map['follower'] ?? "",
      following: map['following'] ?? "",
      reviews: map['reviews'] ?? "",
      bio: map['bio'] ?? "",
      created_on: map['created_on'] ?? "",
      profile_pic: map['profile_pic'] ?? "",
      user_name: map['user_name'] ?? "",
      email: map['email'] ?? "",
      followerList: map['followerList'] ?? "",
      reviewList: map['reviewList'] ?? "",
      followingList: map['followingList'] ?? "",
      communityList: map['communityList'] ?? "",
      delivered: map['delivered'] ?? "",
      token: map['token'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory DriverModel.fromJson(String source) =>
      DriverModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DriverModel(uid: $uid, follower: $follower, following: $following, reviews: $reviews, bio: $bio, created_on: $created_on, profile_pic: $profile_pic, user_name: $user_name, email: $email, followerList: $followerList, reviewList: $reviewList, followingList: $followingList, communityList: $communityList, delivered: $delivered, token: $token)';
  }

  @override
  bool operator ==(covariant DriverModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.follower == follower &&
        other.following == following &&
        other.reviews == reviews &&
        other.bio == bio &&
        other.created_on == created_on &&
        other.profile_pic == profile_pic &&
        other.user_name == user_name &&
        other.email == email &&
        listEquals(other.followerList, followerList) &&
        listEquals(other.reviewList, reviewList) &&
        listEquals(other.followingList, followingList) &&
        listEquals(other.communityList, communityList) &&
        other.delivered == delivered &&
        other.token == token;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        follower.hashCode ^
        following.hashCode ^
        reviews.hashCode ^
        bio.hashCode ^
        created_on.hashCode ^
        profile_pic.hashCode ^
        user_name.hashCode ^
        email.hashCode ^
        followerList.hashCode ^
        reviewList.hashCode ^
        followingList.hashCode ^
        communityList.hashCode ^
        delivered.hashCode ^
        token.hashCode;
  }
}
