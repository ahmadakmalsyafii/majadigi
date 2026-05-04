import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/core/utils/mappers/failure_mapper.dart';
import 'package:majadigi/core/utils/mappers/firebase_auth_helper.dart';
import 'package:majadigi/features/auth/data/model/user_model.dart';

import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String name, String NIK, String phoneNumber, DateTime dateOfBirth);
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Stream<UserModel> get userStream;
}


class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRemoteDataSourceImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> saveUserData(UserModel user) async {
    await _firestore.collection("users").doc(user.uid).set(user.toJson());
  }

  Future<UserModel> signIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;

      if (user == null) {
        throw Exception('Sign in returned null user.');
      }

      final doc = await _firestore.collection("users").doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }

      return UserModel.fromFirebase(user);
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    } catch (e) {
      throw UnknownAuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw UnknownAuthException(message: 'Gagal melakukan sign out: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUp(String name, String email, String password, String NIK, phoneNumber, DateTime dateOfBirth) async {
    try{
      final userCredential = _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = (await userCredential).user;

      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          password: password,
          address: "",
          phoneNumber: phoneNumber,
          NIK: NIK,
          dateOfBirth: dateOfBirth,
          gender: "",
        );

        await saveUserData(newUser);
      }


      return UserModel.fromFirebase(user!);

    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    } catch (e) {
      throw UnknownAuthException(message: e.toString());
    }

  }

  @override
  // TODO: implement userStream
  Stream<UserModel> get userStream => throw UnimplementedError();


}