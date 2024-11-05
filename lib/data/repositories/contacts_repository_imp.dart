import 'package:alerta_uaz/data/data_sources/remote/user_service.dart';

class ContactsRepositoryImpl {
  final UserService _userService;

  ContactsRepositoryImpl(this._userService);

  Future<String?> createContact(String nombre, String numeroTelefonico, String idLista) async {
    return await _userService.sendDataNewContact(nombre, numeroTelefonico, idLista);
  }

  Future<bool> deleteContact(String idContactList, String idContact) async {
    return await _userService.sendIdsDeleteContact(idContactList, idContact);
  }

}
