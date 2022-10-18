// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_list/app/core/exception/auth_exception.dart';
import 'package:todo_list/app/core/notifier/default_notifier.dart';

import 'package:todo_list/app/services/user/user_service.dart';

class RegisterController extends DefaultNotifier {
  final UserService _userService;

  RegisterController({
    required UserService userService,
  }) : _userService = userService;

  Future<void> registerUser(String email, String password) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      final user = await _userService.register(email, password);
      (user != null) ? success() : null;
    } on Exception catch (e) {
      print(e);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
