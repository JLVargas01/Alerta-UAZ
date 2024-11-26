import 'dart:convert';
import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';

class UserService {
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portUser);

  Future<Map<String, dynamic>> signInUser(
    String nameUser,
    String emailUser,
    String phoneUser,
    String avatarUserUrl,
    String deviceToken,
  ) async {
    String endpoint = ApiConfig.singIn;
    Uri uri = Uri.parse('$_baseUrl$endpoint');

    Map<String, dynamic> data = {
      'name': nameUser,
      'email': emailUser,
      'phone': phoneUser,
      'avatar': avatarUserUrl,
      'token': deviceToken,
    };

    try {
      final response = await HttpHelper.post(uri, data);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Convertir la respuesta a Map
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception('${errorResponse['error']}');
      }
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }

  Future<Map<String, dynamic>?> findUserByEmail(String email) async {
    String endpoint = ApiConfig.getInfoUserByEmail;
    Uri uri = Uri.parse('$_baseUrl$endpoint/$email');

    try {
      final response = await HttpHelper.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
          'Error en la solicitud: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Error al buscar usuario: $e');
    }
  }

  Future<String?> sendDataNewContact(String name, String phone, String contactListId) async {
    String endpoint = ApiConfig.createContact;
    Uri uri = Uri.parse('$_baseUrl$endpoint');

    Map<String, dynamic> data = {
      'id_listConta': contactListId,
      'alias': name,
      'telephone': phone,
    };

    try {
      final response = await HttpHelper.post(uri, data);

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['id'] as String?;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception('Error: ${errorResponse['error']}');
      }
    } catch (e) {
      throw Exception('Error al crear contacto: $e');
    }
  }

  Future<bool> sendIdsDeleteContact(String contactListId, String contactId) async {
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
