import 'package:alerta_uaz/data/data_sources/remote/user_service.dart';
import 'package:alerta_uaz/data/repositories/contacts_repository_imp.dart';
import 'package:alerta_uaz/domain/model/cont-confianza_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

abstract class ContactsEvent {}

class LoadContacts extends ContactsEvent {}

class AddContact extends ContactsEvent {}

class RemoveContact extends ContactsEvent {
  final String idConfianza;
  RemoveContact(this.idConfianza);
}

abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<ContactoConfianza> contactos;
  ContactsLoaded(this.contactos);
}

class ContactsError extends ContactsState {
  final String message;
  ContactsError(this.message);
}

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final ContactsRepositoryImpl _contactsRepositoryImpl = ContactsRepositoryImpl(UserService());

  ContactsBloc() : super(ContactsInitial()) {
    on<LoadContacts>((event, emit) async {
      emit(ContactsLoading());
      try {
        emit(ContactsLoaded(await _contactsRepositoryImpl.getAllContacts()));
      } catch (e) {
        emit(ContactsError(e.toString()));
      }
    });

    on<AddContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        Contact contactSelected = await _contactsRepositoryImpl.selecNativeContact();
        String idNewContact = await _contactsRepositoryImpl.createContact(contactSelected);
        await _contactsRepositoryImpl.storeContact(idNewContact, contactSelected);
        emit(ContactsLoaded(await _contactsRepositoryImpl.getAllContacts()));
      } catch (e) {
        emit(ContactsError(e.toString()));
      }
    });

    on<RemoveContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        _contactsRepositoryImpl.purgeContact(event.idConfianza);
        emit(ContactsLoaded(await _contactsRepositoryImpl.getAllContacts()));
      } catch (e) {
        emit(ContactsError(e.toString()));
      }
    });
  }
}
