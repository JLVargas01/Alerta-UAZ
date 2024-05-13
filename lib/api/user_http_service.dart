import 'dart:convert';

import 'package:http/http.dart' as http;

class UsuarioHttpService {
  final String _url = "http://192.168.1.2:4000/api/"; //IP  
  final String _headerKey = "********************************************";
  final String _endPointUsers = "usuario/";

  Future<bool> enviarInicioSesionApi(Map<String, dynamic> userData) async {
    
    String bySinginUser  = 'loguear';
    Uri uri = Uri.parse(_url + _endPointUsers + bySinginUser);
    
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

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // 
  //Este metodo no se utiliza, se espera que se use en un futuro
  //
  Future<bool> findUserByEmail(String emailUser) async {
    String byUserRoute = 'ByEmail/';
    Uri uri = Uri.parse(_url + _endPointUsers+ byUserRoute);
    Uri urlPointGetUser = Uri.parse('$uri$emailUser');
    var response = await http.get(urlPointGetUser);

    if(response.statusCode == 200){
      return true;
    }else {
      return false;
    }

  }

  // 
  //*** Este metodo no se utiliza por la nueva manera de crear usuarios
  //
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
      return true;
    } else {
      return false;
    }
  }

}
