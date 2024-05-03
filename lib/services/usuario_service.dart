import 'package:alerta_uaz/api/user_http_service.dart';

class UsuarioServices {

  late UsuarioHttpService usuarioServApi;

  UsuarioServices() {
    usuarioServApi = UsuarioHttpService();
  }

  Future<bool> inicioSesionApi(String emailUser, String nameUser) async {
    Map<String, dynamic> parametersSend = {
      'Nombre': nameUser,
      'Correo_Electronico': emailUser
    };
    bool encontrado = await usuarioServApi.enviarInicioSesionApi(parametersSend);
    return encontrado;
  }

  // 
  //  *** Este metodo no se utiliza por la nueva manera de crear usuarios
  //
  Future<bool> crearUsuario(String emailUser, String nameUser) async {
    Map<String, dynamic> parametersSend = {
      'Nombre': nameUser,
      'Correo_Electronico': emailUser
    };
    bool resultado = await usuarioServApi.createUserPost(parametersSend);
    return resultado;
  }

}
