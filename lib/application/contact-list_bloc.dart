import 'package:alerta_uaz/domain/model/cont-confianza_model.dart';
import 'package:alerta_uaz/services/contacts_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

abstract class ContactsEvent {}

class LoadContacts extends ContactsEvent {}

class AddContact extends ContactsEvent {}

class RemoveContact extends ContactsEvent {
  final int id_confianza;
  RemoveContact(this.id_confianza);
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
  final contacsDB = ContactosConfianza();
  Future<List<ContactoConfianza>>? futureContcs;

  ContactsBloc() : super(ContactsInitial()) {
    on<LoadContacts>((event, emit) async {
      emit(ContactsLoading());
      try {
        final contactos = await contacsDB.contactos();
        emit(ContactsLoaded(contactos));
      } catch (e) {
        emit(ContactsError('Error al cargar contactos: ${e.toString()}'));
      }
    });

    on<AddContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        //Tomar los datos del contacto seleccionado
        final PhoneContact contactPicker = await FlutterContactPicker.pickPhoneContact();
        String numeroTelefonico = contactPicker.phoneNumber?.number ?? '';
        String nombreCompleto = contactPicker.fullName ?? '';

        /*
        //
        //Hacer un registro en el servidor
        //TODO
        // Tomar el id del registro del usuario para crear el usuario
        //
         */

        //Hacer el registro en la db local
        ContactoConfianza nuevoContacto = ContactoConfianza(
          id_confianza: 1,  //Este id es temporal, no funcionara mas de una vez
          alias: nombreCompleto,  //ok
          telephone: numeroTelefonico,  //ok
          relacion: '', //Este dato es temporal, se debe desarrollar algo para obtenerlo
          );
        await contacsDB.insertContacto(nuevoContacto);

        // Recargamos la lista de contactos
        final contactos = await contacsDB.contactos();
        emit(ContactsLoaded(contactos));
      } catch (e) {
        emit(ContactsError('Error al agregar contacto: ${e.toString()}'));
      }
    });

    on<RemoveContact>((event, emit) async {
      emit(ContactsLoading());
      try {
        await contacsDB.eliminarContacto(event.id_confianza);
        final contactos = await contacsDB.contactos();
        emit(ContactsLoaded(contactos));
      } catch (e) {
        emit(ContactsError('Error al eliminar contacto: ${e.toString()}'));
      }
    });
  }
}
