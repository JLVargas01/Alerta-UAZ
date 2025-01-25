import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';

class UserApi {
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portUser, 'user');

  /// Crea y registra datos del usuario en el servidor.
  Future<Map<String, dynamic>?> create(Map<String, dynamic> data) async {
    const endpoint = '/create';
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await HttpHelper.post(uri, data);

      if (response.statusCode == 201) {
        data = json.decode(response.body);
        return data; // El usuario ha sido registrado.
      } else {
        return null; // Usuario ya existe - 409.
      }
    } catch (_) {
      rethrow;
    }
  }

  /// Verifica si el correo existe en el servidor.
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final endpoint = '/byEmail/$email';

    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await HttpHelper.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // El usuario está registrado.
      } else {
        return null; // El usuario no está registrado - 401.
      }

      // if (response.statusCode == 200) {
      //   return json.decode(response.body); // Encontró el usuario.
      // } else if (response.statusCode == 404) {
      //   return null; // El usuario no existe.
      // } else {
      //   throw HttpHelper.errorInServer;
      // }
    } catch (_) {
      rethrow;
    }
  }

  /// Actualiza el token del usuario en caso de llegar a caducar ó cerrar sesión.
  Future<String> updateToken(String userId, String newToken) async {
    final endpoint = '/byId/$userId/token/$newToken';

    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      var response = await HttpHelper.patch(uri);

      response = HttpHelper.handleResponse(response);

      return json.decode(response.body)['token'];
    } catch (_) {
      rethrow;
    }
  }
}
