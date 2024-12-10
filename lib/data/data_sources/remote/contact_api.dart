import 'dart:convert';
import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';

class ContactApi {
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portUser, 'contact');

  Future<List<dynamic>?> getContactList(String contactListId) async {
    String endpoint = '/list/byId/$contactListId';
    Uri uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await HttpHelper.get(uri);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['contactList'];
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Función que crea un nuevo contacto desde el servidor.
  Future<String?> sendDataNewContact(
      String name, String phone, String contactListId) async {
    String endpoint = '/create/$contactListId';
    Uri uri = Uri.parse('$_baseUrl$endpoint');

    Map<String, dynamic> data = {
      'alias': name,
      'phone': phone,
    };

    try {
      final response = await HttpHelper.post(uri, data);

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['contact_id'];
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
            'Error al crear el contacto, por favor intente más tarde');
      }
    } catch (e) {
      throw Exception('Error al crear contacto: $e');
    }
  }

  Future<Map<String, dynamic>?> getContactByPhone(
      String contactListId, String phone) async {
    String endpoint = '/byPhone/$contactListId/$phone';
    Uri uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await HttpHelper.get(uri);

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw 'Hubo un error en el servidor: ${data['message']}';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendIdsDeleteContact(
      String contactListId, String contactId) async {
    String endpoint = '/delete/$contactListId/$contactId';
    Uri uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await HttpHelper.delete(uri);

      if (response.statusCode != 200) {
        final errorResponse = jsonDecode(response.body);
        throw errorResponse['error'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
