import 'dart:convert';
import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';

class UserService {
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portUser);

  Future<String?> sendDataNewContact(
      String name, String phone, String idContactsList) async {
    String endpoint = ApiConfig.createContact;
    Uri uri = Uri.parse('$_baseUrl$endpoint');

    Map<String, dynamic> data = {
      'idContactsList': idContactsList,
      'alias': name,
      'phone': phone,
    };

    try {
      final response = await HttpHelper.post(uri, data);

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['id_contact'] as String?;
      } else if (response.statusCode == 404) {
        return '';
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error al crear contacto: $e');
    }
  }

  Future<bool> sendIdsDeleteContact(
      String contactListId, String contactId) async {
    String endpoint = '${ApiConfig.deleteContact}/$contactListId/$contactId';
    Uri uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await HttpHelper.delete(uri);

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception('Error: ${errorResponse['error']}');
      }
    } catch (e) {
      throw Exception('Error al eliminar contacto: $e');
    }
  }
}
