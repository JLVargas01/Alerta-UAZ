import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';
import 'package:http/http.dart' as http;

class UserApi {
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portUser, 'user');

  Future<Map<String, dynamic>> signIn(Map<String, dynamic> data) async {
    const endpoint = '/create';
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      http.Response response = await HttpHelper.post(uri, data);

      data = json.decode(response.body);

      if (response.statusCode == 201) {
        return data; // El usuario ha sido registrado.
      } else {
        throw data['message']; // Hubo un error al crear el usuario.
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<Map<String, dynamic>> logIn(String email) async {
    final endpoint = '/byEmail/$email';

    final uri = Uri.parse('$_baseUrl$endpoint');

    Map<String, dynamic> data = {};

    try {
      http.Response response = await HttpHelper.post(uri, data);
      data = json.decode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw data['message'];
      }
    } catch (error) {
      throw error.toString();
    }
  }
}
