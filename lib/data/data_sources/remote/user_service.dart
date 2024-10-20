import 'dart:convert';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String? _protocol = dotenv.env['PROTOCOL'];
  final String? _hostname = dotenv.env['HOST_NAME'];
  final String? _port = dotenv.env['PORT_USER'];

  String? _baseURL;

  UserService() {
    if (_protocol == null || _hostname == null || _port == null) {
      throw Exception(
          'Error: Asegúrate de que PROTOCOL, HOST_NAME y PORT_USER están definidos.');
    }
    _baseURL = '$_protocol://$_hostname:$_port';
  }

  Future<User?> signInUser(User user) async {
    String? endpoint = dotenv.env['USER_SIGN_IN'];

    Uri uri = Uri.parse('$_baseURL$endpoint');

    Map<String, dynamic> data = user.toJson();

    final response = await _sendData(data, uri);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return User.fromJson(responseData);
    } else {
      return null;
    }
  }

  Future<String?> sendDataNewContact(String nombre, String telefono, String idLista) async {
    String? endpoint = dotenv.env['USER_CREATE_CONTACT'];

    Uri uri = Uri.parse('$_baseURL$endpoint');

    Map<String, dynamic> parametersSend = {
      'id_listConta': idLista,
      'alias': nombre,
      'telephone': telefono
    };
    final response = await _sendData(parametersSend, uri);
    if (response.statusCode == 201) {
      return response.body;
    } else {
      return null;
    }
  }


  Future<http.Response> _sendData(Map<String, dynamic> data, Uri uri) async {
    const headerKey = "********************************************";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': headerKey,
    };

    http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );

    return response;
  }
}
