/*
/// Servicio para la gestión de usuarios a través de la API.
/// Permite registrar usuarios, verificar su existencia por correo y actualizar su token de sesión.
*/

import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';

class UserApi {
  /// URL base para la conexión con la API de usuarios.
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portUser, 'user');

  /// Crea y registra datos del usuario en el servidor.
  /// [data] : Mapa con la información del usuario a registrar.
  /// Retorna un [Map] con los datos del usuario si el registro es exitoso,
  /// o 'null' si el usuario ya existe.
  Future<Map<String, dynamic>?> create(Map<String, dynamic> data) async {
    const endpoint = '/create';
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await HttpHelper.post(uri, data);

      if (response.statusCode == 201) {
        data = json.decode(response.body);
        return data; // El usuario ha sido registrado.
      } else {
        return null; // Usuario ya existe - status 409.
      }
    } catch (_) {
      rethrow;
    }
  }

  /// Verifica si el correo existe en el servidor.
  /// [email] : Dirección de correo electrónico a buscar.
  /// Retorna un [Map] con los datos del usuario si está registrado,
  /// o 'null' si el usuario no existe.
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final endpoint = '/byEmail/$email';
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await HttpHelper.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // El usuario está registrado.
      } else {
        return null; // El usuario no está registrado - status 401.
      }
    } catch (_) {
      rethrow;
    }
  }

  /// Actualiza el token del usuario en caso de expiración o cierre de sesión.
  /// [userId] : Identificador del usuario.
  /// [newToken] : Nuevo token a actualizar.
  /// Retorna el nuevo token actualizado.
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
