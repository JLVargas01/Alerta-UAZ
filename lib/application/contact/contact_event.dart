import 'package:equatable/equatable.dart';

/*
//  Clase abstracta para los eventos de los contactos
*/
abstract class ContactsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/*
//  Carga la lista de contactos
*/
class LoadContactList extends ContactsEvent {}

/*
//  Evento para seleccionar un contacto de la lista nativa del telefono
*/
class SelectContact extends ContactsEvent {}

/*
//  Elimina un contacto registrado como 'de confianza'
*/
class RemoveContact extends ContactsEvent {
  final String idConfianza;
  RemoveContact(this.idConfianza);

  @override
  List<Object?> get props => [idConfianza];
}

/*
//  Evento para registrar un nuevo contacto como 'de confianza
//  Se requiere los siguientes parametros:
// - String phoneNumber que representa un numero de telefono
// - String nameContact que representa el nombre del nuevo contacto
*/
class AddContact extends ContactsEvent {
  final String phoneNumber;
  final String nameContact;
  AddContact(this.phoneNumber, this.nameContact);

  @override
  List<Object?> get props => [phoneNumber, nameContact];
}
