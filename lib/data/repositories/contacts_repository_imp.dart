import 'package:alerta_uaz/data/data_sources/local/contacts_db.dart';
import 'package:alerta_uaz/data/data_sources/local/user_storange.dart';
import 'package:alerta_uaz/data/data_sources/remote/user_service.dart';
import 'package:alerta_uaz/domain/model/cont-confianza_model.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

class ContactsRepositoryImpl {
  final UserService _userService;
  final ContactosConfianza contactsDB = ContactosConfianza();

  ContactsRepositoryImpl(this._userService);

  Future<List<ContactoConfianza>> getAllContacts() async {
    try {
      return await contactsDB.contactos();
    } catch (e) {
      rethrow;
    }
  }

  Future<Contact> selecNativeContact() async {
    try {
      final FlutterNativeContactPicker contactPicker =
          FlutterNativeContactPicker();
      Contact? contact = await contactPicker.selectContact();

      if (contact == null) {
        throw 'Error al seleccionar el contacto';
      }
      return contact;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getIdContactsList() async {
    try {
      String? idLista = await UserStorage.getIdListContaData();
      if (idLista == null) {
        throw 'Error al autenticar al usuario';
      }
      return idLista;
    } catch (e) {
      rethrow;
    }
  }

  Future<Contact> validateContact(Contact contact) async {
    try {
      String? numeroTelefonico = contact.phoneNumbers?.single;
      String? nombre = contact.fullName;

      // Verificar si el número telefónico y el nombre son válidos
      if (nombre == null ||
          numeroTelefonico == null ||
          numeroTelefonico.isEmpty) {
        throw ('Los datos del contacto son inválidos');
      }

      //Verificar si el contacto ya esta almacenado
      if (await contactsDB.existContact(numeroTelefonico)) {
        throw 'El contacto ya esta agregado';
      }
      return contact;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> createContact(
      String phoneNewContact, String nameNewContact) async {
    try {
      String idListContacts = await getIdContactsList();
      return await _userService.sendDataNewContact(
          nameNewContact, phoneNewContact, idListContacts);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> storeContact(String idNewContact, String phoneNewContact,
      String nameNewContact) async {
    try {
      if (idNewContact.isEmpty) {
        throw ('El contacto no está registrado en el sistema');
      }

      // Crea un nuevo contacto
      ContactoConfianza nuevoContacto = ContactoConfianza(
        id_confianza: idNewContact,
        alias: nameNewContact,
        telephone: phoneNewContact,
      );
      // Inserta en la base de datos
      await contactsDB.insertContacto(nuevoContacto);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteContact(String idContactList, String idContact) async {
    try {
      return _userService.sendIdsDeleteContact(idContactList, idContact);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> purgeContact(String idContactConf) async {
    try {
      String? idListContacts = await UserStorage.getIdListContaData();
      if (idListContacts == null) {
        throw 'Error con la lista de contactos';
      }
      deleteContact(idListContacts, idContactConf);
      await contactsDB.eliminarContacto(idContactConf);
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> purgeAllContact() async {
  //   try {
  //     await contactsDB.eliminarTodosContacto();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
