import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:majadigi/features/auth/domain/entitiy/user_entity.dart';

class UserModel extends UserEntity {
   UserModel({
     required super.uid,
     required super.name,
     required super.email,
     super.password,
     super.address,
     super.phoneNumber,
     super.NIK,
     super.dateOfBirth,
     super.gender,
  });

   factory UserModel.fromFirebase(fb.User user){
     return UserModel(
         uid: user.uid,
         name: user.displayName ?? "",
         email: user.email ?? "",
         );
   }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json["fullname"],
      email: json['email'],
      password: json['password'],
      address: 'address',
      phoneNumber: 'phoneNumber',
      NIK: 'NIK',
      dateOfBirth: DateTime.now(),
      gender: 'gender',

    );
  }

   factory UserModel.fromJsonString(String source) {
     return UserModel.fromJson(json.decode(source) as Map<String, dynamic>);
   }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'phoneNumber': phoneNumber,
      'NIK': NIK,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender
    };
  }

   String toJsonString() => json.encode(toJson());

   UserModel copyWith({
     String? uid,
     String? email,
     String? name,

   }) {
     return UserModel(
       uid: uid ?? this.uid,
       email: email ?? this.email,
       name: name ?? this.name,
     );
   }

}