import 'package:alerta_uaz/data/data_sources/remote/user_service.dart';
import 'package:alerta_uaz/data/repositories/contacts_repository_imp.dart';
import 'package:alerta_uaz/domain/model/cont-confianza_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

abstract class ContactsEvent {}

class LoadContacts extends ContactsEvent {}

class SelectContact extends ContactsEvent {}

class RemoveContact extends ContactsEvent {
  final String idConfianza;
  RemoveContact(this.idConfianza);
}

class AddContact extends ContactsEvent {
  final String phoneNumber;
  final String nameContact;
  AddContact(this.phoneNumber, this.nameContact);
}

class ResetNavigationState extends ContactsEvent {}

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

    on<SelectContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        Contact contactSelected = await _contactsRepositoryImpl.selecNativeContact();
        emit(NavigateToCompletePhonePage(
          contactSelected.phoneNumbers!.single,
          contactSelected.fullName!,
        ));
      } catch (e) {
        emit(ContactsError("Error al seleccionar el contacto: ${e.toString()}"));
      }
    });

    on<AddContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        final idNewContact = await _contactsRepositoryImpl.createContact(
          event.phoneNumber,
          event.nameContact,
        );
        await _contactsRepositoryImpl.storeContact(idNewContact, event.phoneNumber, event.nameContact);
        emit(ContactAddedSuccessfully());
      } catch (e) {
        emit(ContactsError(e.toString()));
      }
    });

    on<ResetNavigationState>((event, emit) async {
      try {
        emit(ContactsLoaded(await _contactsRepositoryImpl.getAllContacts()));
      } catch (e) {
        emit(ContactsError(e.toString()));
      }
    });

    on<RemoveContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        await _contactsRepositoryImpl.purgeContact(event.idConfianza);
        emit(ContactsLoaded(await _contactsRepositoryImpl.getAllContacts()));
      } catch (e) {
        emit(ContactsError(e.toString()));
      }
    });
  }
}
