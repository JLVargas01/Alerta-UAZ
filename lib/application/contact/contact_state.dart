import 'package:alerta_uaz/domain/model/my_contact_model.dart';

abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class NavigateToCompletePhonePage extends ContactsState {
  final String initialPhoneNumber;
  final String nameContact;

  NavigateToCompletePhonePage(this.initialPhoneNumber, this.nameContact);
}

class ContactAddedSuccessfully extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<MyContact> contactos;
  ContactsLoaded(this.contactos);
}

class ContactsError extends ContactsState {
  final String message;
  ContactsError(this.message);
}
