import 'package:alerta_uaz/data/data_sources/local/user_storange.dart';
import 'package:alerta_uaz/data/data_sources/remote/user_service.dart';
import 'package:alerta_uaz/data/repositories/contacts_repository_imp.dart';
import 'package:alerta_uaz/domain/model/cont-confianza_model.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:alerta_uaz/data/data_sources/local/contacts_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
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
  final ContactosConfianza contactsDB = ContactosConfianza();
  final ContactsRepositoryImpl _contactsRepositoryImpl =
      ContactsRepositoryImpl(UserService());

  ContactsBloc() : super(ContactsInitial()) {
    on<LoadContacts>((event, emit) async {
      emit(ContactsLoading());
      try {
        final contactos = await contactsDB.contactos();
        emit(ContactsLoaded(contactos));
      } catch (e) {
        emit(ContactsError('Error al cargar contactos: ${e.toString()}'));
      }
    });

    on<AddContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        final FlutterNativeContactPicker contactPicker =
            FlutterNativeContactPicker();
        Contact? contact = await contactPicker.selectContact();

        String? numeroTelefonico = contact?.phoneNumbers?.single;
        String? nombre = contact?.fullName;

        // Verificar si el número telefónico y el nombre son válidos
        if (numeroTelefonico == null || nombre == null) {
          emit(ContactsError('Número telefónico o nombre no válidos'));
          return;
        }

        //Verificar si el contacto ya esta almacenado
        if (await contactsDB.existContact(numeroTelefonico)) {
          emit(ContactsError('El contacto ya esta agregado'));
          return;
        }

        String? idLista = await UserStorage.getIdListContaData();
        if (idLista == null) {
          emit(ContactsError('Error al autenticar al usuario'));
          return;
        }

        String? idNewContact = await _contactsRepositoryImpl.createContact(
            nombre, numeroTelefonico, idLista);
        if (idNewContact == null) {
          emit(ContactsError(
              'Error al crear el contacto, por favor intente más tarde'));
          return;
        }
        if (idNewContact.isEmpty) {
          emit(ContactsError('El contacto no esta registrado en el sistema'));
          return;
        }

        // Hacer el registro en la DB local
        ContactoConfianza nuevoContacto = ContactoConfianza(
          id_confianza: idNewContact,
          alias: nombre,
          telephone: numeroTelefonico,
        );
        await contactsDB.insertContacto(nuevoContacto);
        final contactos = await contactsDB.contactos();
        emit(ContactsLoaded(contactos));
      } catch (e) {
        emit(ContactsError('Error al agregar contacto: ${e.toString()}'));
      }
    });

    on<RemoveContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        User? user = await UserStorage.getUserData();
        String? idLista = user!.idContactList;
        if (idLista == null) {
          emit(ContactsError('Error con la lista de contactos'));
          return;
        }
        String idContact = event.idConfianza;
        await _contactsRepositoryImpl.deleteContact(idLista, idContact);
        await contactsDB.eliminarContacto(idContact);
        emit(ContactsLoaded(await contactsDB.contactos()));
      } catch (e) {
        emit(ContactsError('Error al eliminar contacto: ${e.toString()}'));
      }
    });
  }
}
