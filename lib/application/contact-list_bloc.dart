import 'package:alerta_uaz/models/cont_confianza.dart';
import 'package:alerta_uaz/services/contacts_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

abstract class ContactsEvent {}

class LoadContacts extends ContactsEvent {}

class AddContact extends ContactsEvent {
  ContactoConfianza? get contacto => null;
}

class RemoveContact extends ContactsEvent {
  final int id;
  RemoveContact(this.id);
}

abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactosLoaded extends ContactsState {
  final List<ContactoConfianza> contactos;
  ContactosLoaded(this.contactos);
}

class ContactsError extends ContactsState {
  final String message;
  ContactsError(this.message);
}

class PickAndAddContacto extends ContactsEvent {}

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final contacsDB = ContactosConfianza();
  Future<List<ContactoConfianza>>? futureContcs;

  ContactsBloc() : super(ContactsInitial()) {
    on<LoadContacts>((event, emit) async {
      emit(ContactsLoading());
      try {
        final contactos = await contacsDB.contactos();
        emit(ContactosLoaded(contactos));
      } catch (e) {
        emit(ContactsError('Error al cargar contactos: ${e.toString()}'));
      }
    });

    on<AddContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        final PhoneContact contactPicker = await FlutterContactPicker.pickPhoneContact();
        String numeroTelefonico = contactPicker.phoneNumber?.number ?? '';
        String nombreCompleto = contactPicker.fullName ?? '';

        if (numeroTelefonico.isNotEmpty && nombreCompleto.isNotEmpty) {
          ContactoConfianza nuevoContacto = ContactoConfianza(
            telephone: numeroTelefonico,
            name: nombreCompleto,
          );
          await contacsDB.insertContacto(nuevoContacto);

          // Recargamos la lista de contactos
          final contactos = await contacsDB.contactos();
          emit(ContactosLoaded(contactos));
        }
      } catch (e) {
        emit(ContactsError('Error al agregar contacto: ${e.toString()}'));
      }
    });

    on<RemoveContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        await contacsDB.eliminarContacto(event.id);
        final contactos = await contacsDB.contactos();
        emit(ContactosLoaded(contactos));
      } catch (e) {
        emit(ContactsError('Error al eliminar contacto: ${e.toString()}'));
      }
    });
  }
}

