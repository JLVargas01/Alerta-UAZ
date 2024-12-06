import 'dart:convert';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static const String errorInServer =
      'Hay problemas en el servidor, por favor intenelo más tarde.';

  static Map<String, String> _defaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': ApiConfig.headerKey,
    };
  }

  static Future<http.Response> post(Uri url, Map<String, dynamic> data) async {
    try {
      return await http.post(url,
          headers: _defaultHeaders(), body: jsonEncode(data));
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> get(Uri url) async {
    try {
      return await http.get(url, headers: _defaultHeaders());
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> delete(Uri url) async {
    try {
      return await http.delete(url, headers: _defaultHeaders());
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> patch(Uri url) async {
    try {
      return await http.patch(url);
    } catch (e) {
      rethrow;
    }
  }
}
