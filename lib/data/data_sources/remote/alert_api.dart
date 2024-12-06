import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';
import 'package:http/http.dart' as http;

class AlertApi {
  // Default: base url = http://localhost:3002/api/alert
  final _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portAlert, 'alert');

  Future<void> addAlert(Object alertId, Map<String, dynamic> data) async {
    final endpoint = '/add/$alertId';
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      http.Response response = await HttpHelper.post(uri, data);

      if (response.statusCode == 404) {
        throw 'Error al registrar la alerta: La lista de alertas no existe.';
      } else if (response.statusCode >= 500) {
        throw HttpHelper.errorInServer;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getAlertList(String alertListId) async {
    final endpoint = '/getList/$alertListId';
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      http.Response response = await HttpHelper.get(uri);
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
