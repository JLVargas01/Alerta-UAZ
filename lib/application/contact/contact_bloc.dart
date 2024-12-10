import 'package:alerta_uaz/application/contact/contact_event.dart';
import 'package:alerta_uaz/application/contact/contact_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/contact_api.dart';
import 'package:alerta_uaz/data/repositories/contacts_repository_imp.dart';
import 'package:alerta_uaz/domain/model/my_contact_model.dart';
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
        List<MyContact> list =
            await _contactsRepositoryImpl.loadContactsLocal();

        if (list.isEmpty) {
          // Sino hay contactos en local, buscar en el servidor
          list = await _contactsRepositoryImpl.loadContactsServer();
        }

        emit(ContactsLoaded(list));
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
        final contactId = await _contactsRepositoryImpl.createContact(
          event.phoneNumber,
          event.nameContact,
        );

        if (contactId != null && contactId.isNotEmpty) {
          await _contactsRepositoryImpl.saveContact(
              contactId, event.phoneNumber, event.nameContact);
        }
      } catch (e) {
        emit(ContactsError(e.toString()));
      } finally {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(ContactAddedSuccessfully());
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
