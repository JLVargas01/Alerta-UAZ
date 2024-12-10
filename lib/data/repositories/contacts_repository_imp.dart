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

  Future<List<MyContact>> loadContactsLocal() async {
    try {
      final list = await _contactDB.getContacts(_user.id!);
      return list;
    } catch (e) {
      rethrow;
    }
  }

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
                  '${contactData['phone']['countryCode']}${contactData['phone']['nacionalNumber']}');

          await _contactDB.insertContact(contact);
          newList.add(contact);
        }
      }

      return newList;
    } catch (e) {
      rethrow;
    }
  }

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

  Future<Contact> validateContact(Contact contact) async {
    try {
      String? phone = contact.phoneNumbers?.single;
      String? name = contact.fullName;

      // Verificar si el número telefónico y el nombre son válidos
      if (name == null || phone == null || phone.isEmpty) {
        throw ('Los datos del contacto son inválidos');
      }

      return contact;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> createContact(
      String newContactPhone, String newContactName) async {
    try {
      final contactListId = _user.idContactList!;

      /// Antes de agregar se verifica que primero si ya había sido agregado
      /// por el usuario.
      final isContactAdded =
          await _contactApi.getContactByPhone(contactListId, newContactPhone);

      // Si existe... deja de ejecutar
      if (isContactAdded != null) throw 'El contacto ya existe.';

      final contactId = await _contactApi.sendDataNewContact(
          newContactName, newContactPhone, contactListId);

      if (contactId == null) throw 'No se pudo agregar el contacto.';

      return contactId;
    } catch (e) {
      rethrow;
    }
  }

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
