import 'package:alerta_uaz/data/data_sources/local/user_storange.dart';
import 'package:alerta_uaz/data/data_sources/remote/user_service.dart';
import 'package:alerta_uaz/data/repositories/contacts_repository_imp.dart';
import 'package:alerta_uaz/domain/model/cont-confianza_model.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:alerta_uaz/data/data_sources/local/contacts_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

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
  final UserStorange _userStorange = UserStorange();
  final ContactsRepositoryImpl _contactsRepositoryImpl = ContactsRepositoryImpl(UserService());

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
        /*
        //  Tomar los datos del contacto seleccionado
        //  nota: aparentemente 'PhoneContact' esta deprecado, pero
        //  aun funciona, es posible que sea necesario cambiar
        //  la libreria a otra
        */
        final PhoneContact contactPicker = await FlutterContactPicker.pickPhoneContact();

        String? numeroTelefonico = contactPicker.phoneNumber?.number;
        String? nombre = contactPicker.fullName;

        // Verificar si el número telefónico y el nombre son válidos
        if (numeroTelefonico == null || nombre == null) {
          emit(ContactsError('Número telefónico o nombre no válidos'));
          return;
        }

        User? user = await _userStorange.getUser();
        String? idLista = user?.idContacts;
        if (idLista == null) {
          emit(ContactsError('Error al autenticar al usuario'));
          return;
        }

        String? idNewContact = await _contactsRepositoryImpl.createContact(nombre, numeroTelefonico, idLista);
        if (idNewContact != null) {
          // Hacer el registro en la DB local
          ContactoConfianza nuevoContacto = ContactoConfianza(
            id_confianza: idNewContact,
            alias: nombre,
            telephone: numeroTelefonico,
          );

          await contactsDB.insertContacto(nuevoContacto);
        } else {
          emit(ContactsError('Error al crear el contacto, por favor intente más tarde'));
          return;
        }
        final contactos = await contactsDB.contactos();
        emit(ContactsLoaded(contactos));
      } catch (e) {
        emit(ContactsError('Error al agregar contacto: ${e.toString()}'));
      }
    });

    on<RemoveContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        await contactsDB.eliminarContacto(event.idConfianza);
        final contactos = await contactsDB.contactos();
        emit(ContactsLoaded(contactos));
      } catch (e) {
        emit(ContactsError('Error al eliminar contacto: ${e.toString()}'));
      }
    });
  }
}
