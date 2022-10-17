import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:todo_list/app/core/exception/auth_exception.dart';

import 'package:todo_list/app/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  UserRepositoryImpl({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;
  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredencial = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredencial.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-exists") {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains("password")) {
          throw AuthException(message: "E-mail ja casdastrado");
        } else {
          throw AuthException(message: "Utilize o acesso pelo google");
        }
      } else {
        AuthException(message: "Erro ao cadastrar");
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredencial = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredencial.user;
    } on PlatformException catch (e) {
      throw AuthException(message: e.message ?? "Error ao realizar login");
    } on AuthException catch (e) {
      throw AuthException(message: e.message ?? "Error ao realizar login");
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final loginTypes = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      if (loginTypes.contains("password")) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginTypes.contains("google")) {
        throw AuthException(message: "Utilize o google para fazer o login");
      } else {
        throw AuthException(message: "E-mail não cadastrado:");
      }
    } on AuthException catch (e) {
      throw AuthException(message: "E-mail não cadastrado:");
    } on Exception catch (e) {
      if (e is FirebaseAuthException) {
        print(e);
        if (e.code == "invalid-email") {
          throw AuthException(message: "E-mail Inválido:");
        } else {
          throw AuthException(message: e.message);
        }
      }
    }
  }
}
