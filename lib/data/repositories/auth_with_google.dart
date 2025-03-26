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

  /// Inicia sesión con Google y verifica si el usuario ya está registrado.
  /// Si está registrado, actualiza su token y guarda la sesión localmente.
  @override
  Future<User?> signIn() async {
    try {
      // Obtenemos el correo seleccionado por el usuario.
      GoogleSignInAccount? userGoogle = await _googleSignIn.signIn();

      if (userGoogle == null) {
        throw 'No se selecciono ningún correo.';
      }

      // Verificamos si el usuario ya está registrado en la base de datos.
      final user = await _userApi.getUserByEmail(userGoogle.email);

      // Si el usuario no está registrado, se retorna null.
      if (user == null) return null;

      // Cargamos los datos del usuario autenticado.
      _user.fromJson(user);

      // Cerramos sesión de Google después de obtener la información.
      await _googleSignIn.signOut();

      // Obtenemos un nuevo token para recibir notificaciones.
      String? newToken = await FirebaseMessagingService.getToken();

      if (newToken == null) {
        throw "Error al actualizar el token. Inténtelo más tarde.";
      }

      // Actualizamos el token en el servidor.
      _user.token = await _userApi.updateToken(_user.id!, newToken);

      // Guardamos la información del usuario localmente.
      await _storage.save(_user.toJson());

      return _user;
    } catch (e) {
      await _googleSignIn.signOut();
      rethrow;
    }
  }

  /// Cierra sesión del usuario, eliminando los datos almacenados localmente.
  @override
  Future<void> signOut() async {
    try {
      // Eliminamos la información del usuario almacenada en el dispositivo.
      await _storage.clean();
      _user.clean();

      // Eliminamos el token de notificaciones para dejar de recibirlas.
      FirebaseMessagingService.deleteToken();
    } catch (e) {
      rethrow;
    }
  }

  /// Completa el registro del usuario con el número de teléfono proporcionado.
  Future<User> requestPhone(String phone) async {
    try {
      // Obtenemos la cuenta de Google del usuario actual.
      GoogleSignInAccount userGoogle = _googleSignIn.currentUser!;

      // Asignamos los datos obtenidos de Google al usuario.
      _user.name = userGoogle.displayName;
      _user.email = userGoogle.email;
      _user.avatar = userGoogle.photoUrl;
      _user.phone = phone;

      // Generamos un nuevo token para notificaciones.
      _user.token = await FirebaseMessagingService.getToken();

      // Convertimos la información a un formato JSON para enviarla al servidor.
      Map<String, dynamic>? data = _user.toJson();

      // Registramos el usuario en el servidor y obtenemos la respuesta.
      data = await _userApi.create(data);

      // Actualizamos la instancia local del usuario con los datos del servidor.
      _user.fromJson(data!);

      // Cerramos sesión de Google después del registro.
      await _googleSignIn.signOut();

      return _user;
    } catch (e) {
      rethrow;
    }
  }

  /// Verifica si hay un usuario autenticado localmente.
  /// Retorna los datos del usuario si están almacenados, de lo contrario retorna null.
  @override
  Future<User?> checkUserAuthentication() async {
    final isUserAuthenticated = await _storage.load();

    // Si no hay datos guardados, retornamos null.
    if (isUserAuthenticated == null) return null;

    // Existe, ahora se usara en todo el ciclo de vide de la aplicación.
    _user.fromJson(isUserAuthenticated);

    return _user;
  }

  /// Cancela el proceso de autenticación cerrando sesión en Google.
  void cancelAuth() async {
    await _googleSignIn.signOut();
  }
}
