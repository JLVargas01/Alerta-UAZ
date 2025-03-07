/*
//  Clase abstracta para los eventos en la autenticación
*/
abstract class AuthEvent {}

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
}

/*
//  Evento que cancela la autenticacion
*/
class CancelAuth extends AuthEvent {}
