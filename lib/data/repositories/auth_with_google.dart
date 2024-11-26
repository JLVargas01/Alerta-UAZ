import 'package:alerta_uaz/data/data_sources/remote/firebase_service.dart';
import 'package:alerta_uaz/data/data_sources/remote/google_sign_in_service.dart';
import 'package:alerta_uaz/data/data_sources/remote/user_api.dart';
import 'package:alerta_uaz/domain/repositories/auth_repository.dart';

class AuthWithGoogle extends AuthRepository {
  final _googleSignIn = GoogleSignInService();
  final UserApi _userApi;

  AuthWithGoogle(this._userApi);

  @override
  Future<void> logIn(String? email) async {
    // Verificamos si el correo proporcionado no sea nulo.
    if (email != null && email.isNotEmpty) {
      final data = await _userApi.logIn(email);
      user.fromJson(data);
    } else {
      // Caso contrario, mandamos un error.
      throw 'No se proporcionó ningún correo.';
    }
  }

  @override
  Future<void> logOut() async {
    // Cerramos sesión de google en caso de estar abierto.
    await _googleSignIn.logOut();
    // Limpiamos el usuario registrado localmente.
    await storage.clean();
  }

  @override
  Future<void> signIn(String phone) async {
    // Obtenemos los datos del usuario usando su cuenta de google
    final userGoogle = await _googleSignIn.signIn();

    if (userGoogle != null) {
      // Guardamos los datos recolectados de google a un objeto usuario.
      user.name = userGoogle.displayName;
      user.email = userGoogle.email;
      user.avatar = userGoogle.photoUrl;
      user.phone = phone;

      // Obtenemos el token del usuario usando la herramienta firebase messaging
      user.token = await FirebaseService().getToken();

      // Serializamos los datos para poder enviarlos al servidor.
      final Map<String, dynamic> data = user.toJson();

      // enviamos los datos
      final responseData = await _userApi.signIn(data);

      // Y actualizamos para poder usar el usuario en todo el ciclo de vida de la aplicación.
      user.fromJson(responseData);
    } else {
      throw 'La cuenta proporcionada no existe.';
    }
  }
}
