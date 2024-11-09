import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';
import 'package:http/http.dart' as http;

class NotificationApi {
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portNotification);

  Future<void> sendAlert(String contacts, Map<String, Object> message) async {
    String? endpoint = '${ApiConfig.notificationAlert}/$contacts';

    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      http.Response response = await HttpHelper.post(uri, message);

      if (response.statusCode != 200) {
        throw json.decode(response.body)['error'];
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
