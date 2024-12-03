import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';
import 'package:http/http.dart' as http;

class NotificationApi {
  // Default: base url = http://localhost:3003/api/notification
  final String _baseUrl =
      ApiConfig.getBaseUrl(ApiConfig.portNotification, 'notification');

  Future<void> sendAlert(String contactsId, Map<String, Object> message) async {
    String? endpoint = '/send/alert/$contactsId';

    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      http.Response response = await HttpHelper.post(uri, message);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == 0) {
          throw 'Las notificaciones no pudieron ser entregadas, hay problemas en el servidor.';
        }
      } else if (response.statusCode == 404) {
        throw 'No tienes contactos que puedan recibir la alerta.';
      } else {
        throw HttpHelper.errorInServer;
      }
    } catch (e) {
      rethrow;
    }
  }
}
