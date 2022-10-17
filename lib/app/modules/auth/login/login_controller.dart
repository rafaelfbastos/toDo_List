// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_list/app/core/exception/auth_exception.dart';
import 'package:todo_list/app/core/notifier/default_notifier.dart';
import 'package:todo_list/app/services/user/user_service.dart';

class LoginController extends DefaultNotifier {
  final UserService _userService;
  String? infoMessage;

  LoginController({
    required UserService userService,
  }) : _userService = userService;

  bool get hashInfo => (infoMessage != null);

  Future<void> login(String email, String password) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();
      final user = await _userService.login(email, password);

      (user != null) ? success() : setError("Usuarios ou senha inválidos");
    } on AuthException catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      infoMessage = null;
      await _userService.forgotPassword(email);
      infoMessage = "Reset password enviado para $email";
    } on AuthException catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
