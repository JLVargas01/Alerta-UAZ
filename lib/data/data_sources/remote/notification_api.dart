import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';

class NotificationApi {
  // Default: base url = http://localhost:3003/api/notification
  final String _baseUrl = ApiConfig.getBaseUrl(
    ApiConfig.portNotification,
    'notification',
  );

  Future<Map<String, dynamic>> sendNotification(
    String contactListId,
    Map<String, Object> message,
  ) async {
    String? endpoint = '/send/$contactListId';

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
