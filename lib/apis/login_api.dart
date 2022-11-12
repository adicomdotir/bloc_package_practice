import 'package:testingbloc_practice/models.dart';

abstract class LoginApiProtocol {
  LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

class LoginApi implements LoginApiProtocol {
  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => email == 'foo@bar.com' && password == 'foobar',
      ).then((isLoggedIn) => isLoggedIn ? LoginHandle.fooBar() : null);
}
