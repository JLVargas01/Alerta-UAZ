abstract class AuthEvent {}

class CheckUserAuthentication extends AuthEvent {}

class SignIn extends AuthEvent {}

class CompleteSignIn extends AuthEvent {
  final String phoneNumber;

  CompleteSignIn(this.phoneNumber);
}


class SignOut extends AuthEvent {}
