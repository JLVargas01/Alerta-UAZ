import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';
import 'package:http/http.dart' as http;

class NotificationApi {
  // base url = http://localhost:3003/api/notification
  final String _baseUrl =
      ApiConfig.getBaseUrl(ApiConfig.portNotification, 'notification');

  Future<void> sendAlert(String contactsId, Map<String, Object> message) async {
    String? endpoint = '/send/alert/$contactsId';

    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      http.Response response = await HttpHelper.post(uri, message);

      final data = json.decode(response.body);

      // No pudo enviar ninguna notificación.
      if (response.statusCode != 200) {
        throw data["message"];
      }
      // Hubo notificaciones que no pudieron ser entregadas.
      if (data["failure"] > 0) {
        throw 'Error con notificaciones: Algunas notificaciones no pudieron ser entregadas a contactos.';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
