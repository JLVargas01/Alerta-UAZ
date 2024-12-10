import 'package:alerta_uaz/domain/model/user_model.dart';

abstract class AuthState {}

class Authenticated extends AuthState {
  final user = User();
}

class Unauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthNeedsPhoneNumber extends AuthState {}
