import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';

class NotificationApi {
  // Default: base url = http://localhost:3003/api/notification
  final String _baseUrl =
      ApiConfig.getBaseUrl(ApiConfig.portNotification, 'notification');

  Future<String> sendNotification(
      String contactListId, Map<String, Object> message) async {
    String? endpoint = '/send/$contactListId';

    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      var response = await HttpHelper.post(uri, message);
      response = HttpHelper.handleResponse(response);

      final data = json.decode(response.body);

      if (data["success"] > 0 && data['failure'] == 0) {
        return 'La notificación ha sido enviada exitosamente.';
      } else if (data["souccess"] > 0 && data['failure'] > 0) {
        return 'Algunas notificaciones no pudieron ser entregadas.';
      } else {
        return 'Hubo problemas al enviar las notificaciones.';
      }

      // if (response.statusCode == 200) {
      //   if (data["success"] == 0) {
      //     throw 'Las notificaciones no pudieron ser entregadas, hay problemas en el servidor.';
      //   }
      // } else if (response.statusCode == 404) {
      //   throw 'No tienes contactos que puedan recibir la alerta.';
      // } else {
      //   throw HttpHelper.errorInServer;
      // }
    } catch (_) {
      rethrow;
    }
  }
}
