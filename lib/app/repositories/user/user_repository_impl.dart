import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      print(e);
      if (e.code == "email-already-in-use") {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains("password")) {
          throw AuthException(message: "E-mail ja casdastrado:");
        } else {
          throw AuthException(message: "Utilize o acesso pelo google:");
        }
      } else {
        AuthException(message: "Erro ao cadastrar:");
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
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        throw AuthException(message: "Senha inválida:");
      }
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

  @override
  Future<User?> googleLogin() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
        if (loginTypes.contains("password")) {
          logout();
          throw AuthException(message: "Cadastro feito com e-mail e senha ");
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseProvider = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
          final userCredential =
              await _firebaseAuth.signInWithCredential(firebaseProvider);
          return userCredential.user;
        }
      }
    } on FirebaseAuthException catch (e) {
      logout();
      print(e);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      user.updateDisplayName(name);
      user.reload();
    }
  }
}
