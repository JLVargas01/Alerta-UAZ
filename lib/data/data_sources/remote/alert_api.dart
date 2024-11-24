import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';
import 'package:http/http.dart' as http;

class AlertApi {
  // base url = http://localhost:3002/api/alert
  final _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portAlert, 'alert');

  Future<void> addAlert(String alertId, Map<String, dynamic> data) async {
    final endpoint = '/add/$alertId';
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      http.Response response = await HttpHelper.post(uri, data);

      data = json.decode(response.body);

      if (response.statusCode != 201) throw data['message'];
    } catch (e) {
      throw e.toString();
    }
  }
}
