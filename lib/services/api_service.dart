import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiService {
  final String _baseUrl = 'http://${dotenv.env['API_URL']}';

  Future<void> sendNotification(String telephone) async {
    const endpoint = "/api/notification/alert";

    await postRequest(endpoint, {
      'data': {'telephone': telephone}
    });
  }

  Future<void> postRequest(String endpoint, Map<String, Object> data) async {
    final url = Uri.parse(_baseUrl + endpoint);

    final response = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(data));

    if (response.statusCode != 200) {
      throw Exception('Failed to post data to $endpoint: ${response.body}');
    }
  }
}
