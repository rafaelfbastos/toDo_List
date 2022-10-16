import 'package:firebase_auth/firebase_auth.dart';
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
    } on FirebaseAuthException catch (e, s) {
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
}
