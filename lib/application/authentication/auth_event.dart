abstract class AuthEvent {}

class CheckUserAuthentication extends AuthEvent {}

class SignIn extends AuthEvent {}

class LogIn extends AuthEvent {}

class ProvidePhoneNumber extends AuthEvent {
  final String phoneNumber;

  ProvidePhoneNumber(this.phoneNumber);
}

class SignOut extends AuthEvent {}
