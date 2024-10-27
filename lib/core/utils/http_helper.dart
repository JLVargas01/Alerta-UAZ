import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static Future<http.Response> post(Uri url, Map<String, dynamic> data) async {
    return await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ApiConfig.headerKey
        },
        body: jsonEncode(data));
  }
}
