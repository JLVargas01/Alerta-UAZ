abstract class AuthEvent {}

class CheckUserAuthentication extends AuthEvent {}

class SignIn extends AuthEvent {}

class SignOut extends AuthEvent {}
