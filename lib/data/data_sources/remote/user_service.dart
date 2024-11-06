import 'dart:convert';
import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';

class UserService {
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portUser);

  Future<Map<String, dynamic>?> signInUser(
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
      print(userDataResponse);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return userDataResponse;
      } else {
        throw Exception('${userDataResponse['error']}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
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
      final dataNewUser = jsonDecode(response.body);
      return dataNewUser['id'];
    } else {
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
