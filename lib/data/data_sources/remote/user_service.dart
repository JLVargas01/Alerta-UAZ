import 'dart:convert';
import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';

class UserService {
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portUser);

  Future<Map<String, dynamic>> signInUser(
    String nameUser,
    String emailUser,
    String phoneUser,
    String avatarUserUrl,
    String deviceToken,
  ) async {
    String endpoint = ApiConfig.singIn;

    try {
      Uri uri = Uri.parse('$_baseUrl$endpoint');

      Map<String, dynamic> data = {
        'name': nameUser,
        'email': emailUser,
        'phone': phoneUser,
        'avatar': avatarUserUrl,
        'token': deviceToken
      };
      final response = await HttpHelper.post(uri, data);
      final userDataResponse = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return userDataResponse;
      } else {
        throw Exception('${userDataResponse['error']}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

Future<Map<String, dynamic>?> findUserByEmail(String emailUser) async {
  final String endpoint = ApiConfig.getInfoUserByEmail;
  final Uri uri = Uri.parse('$_baseUrl$endpoint/$emailUser');

  try {
    final response = await HttpHelper.get(uri);

    if (response.statusCode == 200) {
      // El usuario existe, devolvemos su información
      final userDataResponse = jsonDecode(response.body);
      return userDataResponse;
    } else if (response.statusCode == 404) {
      // El usuario no existe
      return null;
    } else {
      // Error en el servidor u otra respuesta inesperada
      throw Exception('Error en la solicitud: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    throw Exception('Error en el servidor: $e');
  }
}

  Future<String?> sendDataNewContact(
      String nombre, String telefono, String idLista) async {
    String endpoint = ApiConfig.createContact;

    Uri uri = Uri.parse('$_baseUrl$endpoint');

    Map<String, dynamic> parametersSend = {
      'id_listConta': idLista,
      'alias': nombre,
      'telephone': telefono
    };
    final response = await HttpHelper.post(uri, parametersSend);
    if (response.statusCode == 201) {
      //El contacto se creo correctamente
      final dataNewUser = jsonDecode(response.body);
      return dataNewUser['id'];
    } else if(response.statusCode == 404){
      //El contacto no existe
      return '';
    } else {
      //Error en el servidor
      return null;
    }
  }

  Future<bool> sendIdsDeleteContact(String idContactList, String idContact) async {
    String endpoint = '${ApiConfig.deleteContact}/$idContactList/$idContact';
    Uri uri = Uri.parse('$_baseUrl$endpoint');

    final response = await HttpHelper.delete(uri);
    return response.statusCode == 200;
  }
}
