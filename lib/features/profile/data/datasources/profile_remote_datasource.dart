import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/utils/mappers/firebase_auth_helper.dart';
import 'package:majadigi/features/auth/data/model/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> updateProfile(String name, String NIK, DateTime dateOfBirth, String email, String password, String? gender, String? address);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProfileRemoteDataSourceImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserModel> updateProfile(String name, String NIK, DateTime dateOfBirth, String email, String password, String? gender, String? address) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('User not logged in.');
      }

      if (password.isNotEmpty) {
        await user.updatePassword(password);
      }

      final doc = await _firestore.collection("users").doc(user.uid).get();
      UserModel updatedUser;
      if (doc.exists && doc.data() != null) {
        final existingUser = UserModel.fromJson(doc.data()!);
        updatedUser = existingUser.copyWith(
          name: name,
          NIK: NIK,
          dateOfBirth: dateOfBirth,
          email: email,
          password: password,
          gender: gender,
          address: address,
        );
      } else {
        updatedUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          password: password,
          NIK: NIK,
          dateOfBirth: dateOfBirth,
          gender: gender,
          address: address,
        );
      }

      await _firestore.collection("users").doc(user.uid).set(updatedUser.toJson());
      return updatedUser;

    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    } catch (e) {
      throw UnknownAuthException(message: e.toString());
    }
  }
}
