/*
/// 'NotificationApi' maneja las solicitudes HTTP relacionadas con el envío de notificaciones.
/// Esta clase permite enviar notificaciones a una lista de contactos a través del servidor.
*/

import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';

class NotificationApi {

  /// URL base para acceder a los endpoints de notificaciones.
  /// Por defecto, la URL base es 'http://localhost:3003/api/notification'.
  final String _baseUrl = ApiConfig.getBaseUrl(
    ApiConfig.portNotification,
    'notification',
  );

  /// Envía una notificación a una lista de contactos a través del servidor.
  /// [contactListId] - Identificador de la lista de contactos a los que se enviará la notificación.
  /// [message] - Mapa con el contenido de la notificación a enviar.
  /// Retorna un 'Map<String, dynamic>' con la respuesta del servidor.
  /// Si ocurre un error durante el envío, la excepción es propagada.
  Future<Map<String, dynamic>> sendNotification(
    String contactListId,
    Map<String, Object> message,
  ) async {
    String endpoint = '/send/$contactListId';
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      var response = await HttpHelper.post(uri, message);
      response = HttpHelper.handleResponse(response);

      final data = json.decode(response.body);
      return data;
    } catch (_) {
      rethrow;
    }
  }
}
