abstract class AppAction {}

class LoginAction implements AppAction {
  final String email;
  final String password;

  LoginAction({
    required this.email,
    required this.password,
  });
}

class LoadNotesAction implements AppAction {
  LoadNotesAction();
}
