abstract class AuthEvent {}

class CheckUserAuthentication extends AuthEvent {}

class SignIn extends AuthEvent {
  final String? phoneNumber;
  SignIn([this.phoneNumber]);
}


class SignOut extends AuthEvent {}
