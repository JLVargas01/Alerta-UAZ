import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:equatable/equatable.dart';

/*
//  Clase abstracta para los estados en las alertas
//  Es posible enviar un parametro opcional de tipo String que representa un mensaje
*/
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

/*
//  Indica si el usuario está autenticado.
*/
class Authenticated extends AuthState {
  final user = User();
}

/*
//  Indica si el usuario está autenticado.
*/
class Unauthenticated extends AuthState {}

/*
//  Indica que se está realizando una carga relacionada con la autenticacion.
*/
class AuthLoading extends AuthState {}

/*
//  Estado para indicar un error
//  Se requiere un parametro de tipo String message que representa la causa de error
*/
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/*
//  Estado para solicitar un numero de telefono.
*/
class AuthNeedsPhoneNumber extends AuthState {}
