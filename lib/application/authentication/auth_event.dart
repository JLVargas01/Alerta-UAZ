import 'package:equatable/equatable.dart';

/*
//  Clase abstracta para los eventos en la autenticación
*/
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/*
//  Evento para verifica si el usuario está autenticado.
*/
class CheckUserAuthentication extends AuthEvent {}

/*
//  Evento para iniciar sesión
*/
class SignIn extends AuthEvent {}

/*
//  Evento para iniciar sesión
*/
class SignOut extends AuthEvent {}

/*
//  Evento para proporcionar el número de teléfono
*/
class ProvidePhoneNumber extends AuthEvent {
  final String phoneNumber;

  ProvidePhoneNumber(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

/*
//  Evento que cancela la autenticacion
*/
class CancelAuth extends AuthEvent {}
