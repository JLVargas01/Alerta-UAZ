import 'package:alerta_uaz/api/user_http_service.dart';

class UsuarioServices {

  late UsuarioHttpService usuarioServApi;

  UsuarioServices() {
    usuarioServApi = UsuarioHttpService();
  }

  Future<void> enviarInicioSesionApi(String emailUser, String nameUser) async {
    bool encontrado = await usuarioServApi.findUserByEmail(emailUser);
    if(!encontrado){
      bool resultadoCreacion = await crearUsuario(emailUser, nameUser);
      if(resultadoCreacion) {
        // Tomar accion si no se pudo crear el suario
      }
    }
  }
  
  Future<bool> crearUsuario(String emailUser, String nameUser) async {
    Map<String, dynamic> parametersSend = {
      'Nombre': nameUser,
      'Correo_Electronico': emailUser
    };
    bool resultado = await usuarioServApi.createUserPost(parametersSend);
    return resultado;
  }

}
