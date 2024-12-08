import 'package:alerta_uaz/application/contact/contact_event.dart';
import 'package:alerta_uaz/application/contact/contact_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/contact_api.dart';
import 'package:alerta_uaz/data/repositories/contacts_repository_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final ContactsRepositoryImpl _contactsRepositoryImpl =
      ContactsRepositoryImpl(ContactApi());

  ContactsBloc() : super(ContactsInitial()) {
    on<LoadContactList>((event, emit) async {
      emit(ContactsLoading());
      try {
        // Busca si hay contactos en local
        final listLocal = await _contactsRepositoryImpl.loadContactsLocal();
        if (listLocal.isNotEmpty) emit(ContactsLoaded(listLocal));

        // Sino hay contactos en local, buscar en el servidor
        final listServer = await _contactsRepositoryImpl.loadContactsServer();
        // Mostrara los datos obtenidos, en caso de no obtener nada... igual dara una lista vacía.
        emit(ContactsLoaded(listServer));
      } catch (e) {
        emit(ContactsError(e.toString()));
      }
    });

    on<SelectContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        Contact contactSelected =
            await _contactsRepositoryImpl.selectNativeContact();

        emit(NavigateToCompletePhonePage(
          contactSelected.phoneNumbers!.single,
          contactSelected.fullName!,
        ));
      } catch (e) {
        emit(
            ContactsError("Error al seleccionar el contacto: ${e.toString()}"));
      }
    });

    on<AddContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        final newContactId = await _contactsRepositoryImpl.createContact(
          event.phoneNumber,
          event.nameContact,
        );

        await _contactsRepositoryImpl.saveContact(
            newContactId, event.phoneNumber, event.nameContact);
        emit(ContactAddedSuccessfully());
      } catch (e) {
        emit(ContactsError(e.toString()));
      }
    });

    on<RemoveContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        await _contactsRepositoryImpl.deleteContact(event.idConfianza);
        emit(ContactsLoaded(await _contactsRepositoryImpl.loadContactsLocal()));
      } catch (e) {
        emit(ContactsError(e.toString()));
      }
    });
  }
}
