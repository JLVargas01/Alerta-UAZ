import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portNotification);

  Future<String> notificationAlert(
      String idContact, Map<String, dynamic> data) async {
    String? endpoint = '${ApiConfig.notificationAlert}/$idContact';

    Map<String, Object> message = {
      'notification': {
        'title': '¡Alerta de emergencia!',
        'body':
            '${data['name']} necesita ayuda urgente. Se encuentra en una situación de peligro.'
      },
      'data': data
    };

    return await _sendNotification(endpoint, message);
  }

  Future<String> _sendNotification(
      String endpoint, Map<String, dynamic> data) async {
    final Uri url = Uri.parse(_baseUrl + endpoint);

    try {
      http.Response response = await HttpHelper.post(url, data);

      data = json.decode(response.body);

      if (response.statusCode != 200) {
        throw Exception(data['error'].toString());
      }
      return data['success'].toString();
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }
}
