import 'dart:convert';

import 'package:http/http.dart' as http;

class UsuarioHttpService {
  final String _url = "http://192.168.1.2:4000/api/"; //IP  
  final String _headerKey = "********************************************";
  final String _headerHost = "192.168.1.2";
  final String _endPointUsers = "usuario/";

  Future<String> findUserByEmail(String emailUser) async {
    String byUserRoute = 'ByEmail/';

    var uri = Uri.parse(_url + _endPointUsers+ byUserRoute);

    Uri urlPointGetUser = Uri.parse('$uri$emailUser');
    
    print("************ urlPointGetUser: $urlPointGetUser");
    print(urlPointGetUser);

    var response = await http.get(urlPointGetUser);

    print("************ response.body: ${response.body}");
    print(response.body);

    if(response.statusCode == 200){
      return response.body;
    }else if (response.statusCode == 404) {
      return response.body;
    }else{
      print('\n\n******************Error-inside************************');
      throw(Error);
    }
  }

  Future<bool> createUserPost(Map<String, dynamic> userData) async {
    Uri uri = Uri.parse(_url + _endPointUsers);
    
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': _headerKey,
    };
    
    // Convierte los datos del usuario a JSON
    String jsonBody = jsonEncode(userData);

    var response = await http.post(
      uri,
      headers: headers,
      body: jsonBody,
    );
    
    if (response.statusCode == 201) {
      print('Exito creacion usuario');
      return true;
    } else {
      print('Falla creacion usuario');
      return false;
    }
  }

  // Función para codificar los parámetros en formato URL
  String _encodeParameters(Map<String, dynamic> parameters) {
    return parameters.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}').join('&');
  }

}