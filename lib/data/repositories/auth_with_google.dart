import 'package:alerta_uaz/data/data_sources/local/storage.dart';
import 'package:alerta_uaz/data/data_sources/remote/firebase_messaging.dart';
import 'package:alerta_uaz/data/data_sources/remote/user_api.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:alerta_uaz/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthWithGoogle implements AuthRepository {
  final UserApi _userApi;

  final _user = User();
  final _storage = Storage("user");
  final _googleSignIn = GoogleSignIn();

  AuthWithGoogle(this._userApi);

  @override
  Future<User?> signIn() async {
    try {
      // Obtenemos el correo seleccionado por el usuario.
      GoogleSignInAccount? userGoogle = await _googleSignIn.signIn();

      if (userGoogle == null) {
        throw 'No se selecciono ningún correo.';
      }

      // Verificamos si ya esta registrado.
      final user = await _userApi.getUserByEmail(userGoogle.email);
      // No está registrado.
      if (user == null) return null;

      _user.fromJson(user);
      await _googleSignIn.signOut();
      // Si lo encontró, entonces también actualizamos el token
      String? newtoken = await FirebaseMessagingService.getToken();

      if (newtoken == null) {
        throw "Error al actualizar el token. Intentelo más tarde.";
      }

      _user.token = await _userApi.updateToken(_user.id!, newtoken);

      await _storage.save(_user.toJson());

      return _user;
    } catch (e) {
      await _googleSignIn.signOut();
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Limpiamos el usuario registrado localmente.
      await _storage.clean();
      _user.clean();
      // Borramos token para dejar de recibir notificaciones.
      FirebaseMessagingService.deleteToken();
    } catch (e) {
      rethrow;
    }
  }

  Future<User> requestPhone(String phone) async {
    try {
      GoogleSignInAccount userGoogle = _googleSignIn.currentUser!;

      // Completamos el registro del usuario.
      _user.name = userGoogle.displayName;
      _user.email = userGoogle.email;
      _user.avatar = userGoogle.photoUrl;
      _user.phone = phone;
      _user.token = await FirebaseMessagingService.getToken();

      // Se preparan para poder enviarlos al servidor.
      Map<String, dynamic>? data = _user.toJson();

      data = await _userApi.create(data);

      // Ahora el usuario está registrado.
      _user.fromJson(data!);
      await _googleSignIn.signOut();
      return _user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> checkUserAuthentication() async {
    final isUserAuthenticated = await _storage.load();

    // NO hay ningún dato guardado de manera local.
    if (isUserAuthenticated == null) return null;

    // Existe, ahora se usara en todo el ciclo de vide de la aplicación.
    _user.fromJson(isUserAuthenticated);

    return _user;
  }

  void cancelAuth() async {
    await _googleSignIn.signOut();
  }
}
