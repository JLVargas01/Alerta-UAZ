import 'dart:convert';
import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';

class ContactApi {
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portUser, 'contact');

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

  Future<bool> sendIdsDeleteContact(
      String contactListId, String contactId) async {
    String endpoint = '/delete/$contactListId/$contactId';
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
