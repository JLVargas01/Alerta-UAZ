/*
/// Repositorio para gestionar los contactos del usuario.
/// Se encarga de la comunicación con la API y la base de datos local.
*/

import 'package:alerta_uaz/data/data_sources/local/contact_db.dart';
import 'package:alerta_uaz/data/data_sources/remote/contact_api.dart';
import 'package:alerta_uaz/domain/model/my_contact_model.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

class ContactsRepositoryImpl {
  final ContactApi _contactApi;

  final _contactDB = ContactDB();

  final _user = User();

  ContactsRepositoryImpl(this._contactApi);

  /// Carga los contactos almacenados localmente.
  /// [return] Lista de contactos almacenados en la base de datos local.
  Future<List<MyContact>> loadContactsLocal() async {
    try {
      final list = await _contactDB.getContacts(_user.id!);
      return list;
    } catch (e) {
      rethrow;
    }
  }

  /// Carga los contactos desde el servidor y los guarda en la base de datos local.
  /// [return] Lista de contactos sincronizados con el servidor.
  Future<List<MyContact>> loadContactsServer() async {
    final contactListId = _user.idContactList!;
    List<MyContact> newList = [];
    try {
      final list = await _contactApi.getContactList(contactListId);

      if (list != null) {
        for (Map<String, dynamic> contactData in list) {
          final contact = MyContact(
            uid: _user.id!,
            contactId: contactData['contactId'],
            alias: contactData['alias'],
            phone:
                '${contactData['phone']['countryCode']}${contactData['phone']['nacionalNumber']}',
          );

          await _contactDB.insertContact(contact);
          newList.add(contact);
        }
      }

      return newList;
    } catch (e) {
      rethrow;
    }
  }

  /// Abre el selector de contactos nativo del dispositivo y devuelve el contacto seleccionado.
  /// [return] Contacto seleccionado.
  Future<Contact> selectNativeContact() async {
    try {
      final FlutterNativeContactPicker contactPicker =
          FlutterNativeContactPicker();
      Contact? contact = await contactPicker.selectContact();

      if (contact == null) {
        throw 'Error al seleccionar el contacto';
      }

      return await validateContact(contact);
    } catch (e) {
      rethrow;
    }
  }

  /// Valida que el contacto tenga nombre y número de teléfono.
  /// [contact] Contacto a validar.
  /// [return] Contacto validado.
  Future<Contact> validateContact(Contact contact) async {
    try {
      String? phone = contact.phoneNumbers?.single;
      String? name = contact.fullName;

      if (name == null || phone == null || phone.isEmpty) {
        throw ('Los datos del contacto son inválidos');
      }

      return contact;
    } catch (e) {
      rethrow;
    }
  }

  /// Crea un nuevo contacto en el servidor si no existe previamente.
  /// [newContactPhone] Número del contacto a registrar.
  /// [newContactName] Nombre del contacto a registrar.
  /// [return] ID del contacto registrado en el servidor.
  Future<String?> createContact(
      String newContactPhone, String newContactName) async {
    try {
      final contactListId = _user.idContactList!;

      final isContactAdded =
          await _contactApi.getContactByPhone(contactListId, newContactPhone);

      if (isContactAdded != null) throw 'El contacto ya existe.';

      final contactId = await _contactApi.sendDataNewContact(
          newContactName, newContactPhone, contactListId);

      if (contactId == null) throw 'No se pudo agregar el contacto.';

      return contactId;
    } catch (e) {
      rethrow;
    }
  }

  /// Guarda un contacto en la base de datos local.
  /// [newContactId] ID del contacto registrado en el servidor.
  /// [newPhone] Número del contacto.
  /// [newContactName] Nombre del contacto.
  Future<void> saveContact(
      String? newContactId, String newPhone, String newContactName) async {
    try {
      if (newContactId == null) {
        throw ('El contacto no está registrado en el sistema');
      }

      // Crea un nuevo contacto
      MyContact newContact = MyContact(
        uid: _user.id!,
        contactId: newContactId,
        alias: newContactName,
        phone: newPhone,
      );
      // Inserta en la base de datos
      await _contactDB.insertContact(newContact);
    } catch (e) {
      rethrow;
    }
  }

  /// Elimina un contacto del servidor y de la base de datos local.
  /// [contactId] ID del contacto a eliminar.
  Future<void> deleteContact(String contactId) async {
    try {
      final contactListId = _user.idContactList!;
      await _contactApi.sendIdsDeleteContact(contactListId, contactId);
      await _contactDB.deleteContact(contactId);
    } catch (e) {
      rethrow;
    }
  }
}
