import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instagram/config/paths.dart';
import 'package:flutter_instagram/models/failure_model.dart';
import 'package:flutter_instagram/repositories/auth/base_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository(
      {FirebaseFirestore firebaseFirestore, auth.FirebaseAuth firebaseAuth})
      : _firebaseFirestore = FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Future<User> logInWithEmailAndPassword(
      {String email, String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message);
    }
  }

  @override
  Future<User> signUpWithEmailAndPassword(
      {String username, String email, String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      _firebaseFirestore.collection(Paths.users).doc(user.uid).set(
        {'username': username, 'email': email, 'followers': 0, 'following': 0},
      );
      return user;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message);
    }
  }

  @override
  Stream<User> get user => _firebaseAuth.userChanges();

  @override
  Future<void> logOut() {
    _firebaseAuth.signOut();
  }
}
