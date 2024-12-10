import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';
import 'package:http/http.dart' as http;

class UserApi {
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portUser, 'user');

  // Función que crea y registra un usuario desde el servidor con los datos enviados.
  Future<Map<String, dynamic>?> create(Map<String, dynamic> data) async {
    const endpoint = '/create';
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      http.Response response = await HttpHelper.post(uri, data);

      data = json.decode(response.body);

      if (response.statusCode == 201) {
        return data; // El usuario ha sido registrado.
      } else if (response.statusCode == 409) {
        return null; // Usuario ya existe.
      } else {
        throw HttpHelper.errorInServer;
      }
    } catch (error) {
      rethrow;
    }
  }

  // Función que inicia sesión del usuario verificando correo existente en el servidor.
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final endpoint = '/byEmail/$email';

    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await HttpHelper.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body); // Encontró el usuario.
      } else if (response.statusCode == 404) {
        return null; // El usuario no existe.
      } else {
        throw HttpHelper.errorInServer;
      }
    } catch (error) {
      rethrow;
    }
  }

  // Función para actualizar token del usuario.
  Future<String> updateToken(String userId, String newToken) async {
    final endpoint = '/byId/$userId/token/$newToken';

    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      http.Response response = await HttpHelper.patch(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body)['token'];
      } else {
        throw HttpHelper.errorInServer;
      }
    } catch (error) {
      rethrow;
    }
  }
}
