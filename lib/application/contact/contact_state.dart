import 'package:alerta_uaz/domain/model/my_contact_model.dart';

/*
//  Clase abstracta para los eventos de los contactos
//  Es posible enviar un parametro opcional de tipo String que representa un mensaje
*/
abstract class ContactsState {}

/*
// Estado inicial para contactos
*/
class ContactsInitial extends ContactsState {}

/*
//  Estado para indicar el estado de carga de algo relacionado con los contactos
*/
class ContactsLoading extends ContactsState {}

/*
//  Estado para indicar la navegacion hacia la solicitud al usuario
//  la confirmacion del numero telefonico
//  Se requieren los siguientes parametros
// - Un String initialPhoneNumber que representa el numero telefonico por verificar
// - Un String nameContact que representa el nombre del contacto que se desea verificar
*/
class NavigateToCompletePhonePage extends ContactsState {
  final String initialPhoneNumber;
  final String nameContact;

  NavigateToCompletePhonePage(this.initialPhoneNumber, this.nameContact);
}

/*
//  Estado que representa el correcto proceso de registrar un usuario
*/
class ContactAddedSuccessfully extends ContactsState {}

/*
//  Estado que representa la finalizacion de la carga de la lista de contactos.
//  Se requiere como parametro una lista de objetos de tipo MyContact
//  que representa los contactos registrados como 'de confianza'
*/
class ContactsLoaded extends ContactsState {
  final List<MyContact> contactos;
  ContactsLoaded(this.contactos);
}

/*
//  Estado que representa un estado de error, relacionado con los contactos
*/
class ContactsError extends ContactsState {
  final String message;
  ContactsError(this.message);
}
