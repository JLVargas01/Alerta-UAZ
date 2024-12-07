abstract class AuthEvent {}

class CheckUserAuthentication extends AuthEvent {}

class SignIn extends AuthEvent {}

class LogIn extends AuthEvent {}

class LogOut extends AuthEvent {}

// Este evento solo se creo para cancelar el registro.
class CancelAuth extends AuthEvent {}

class ProvidePhoneNumber extends AuthEvent {
  final String phoneNumber;

  ProvidePhoneNumber(this.phoneNumber);
}
