import 'package:alerta_uaz/data/data_sources/local/storage.dart';
import 'package:alerta_uaz/data/data_sources/remote/firebase_service.dart';
import 'package:alerta_uaz/data/data_sources/remote/user_api.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:alerta_uaz/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthWithGoogle implements AuthRepository {
  final _googleSignIn = GoogleSignIn();
  final UserApi _userApi;

  final _user = User();
  final _storage = Storage("user");

  AuthWithGoogle(this._userApi);

  @override
  Future<void> logIn() async {
    try {
      // Obtenemos el correo seleccionado por el usuario.
      GoogleSignInAccount? userGoogle = await _googleSignIn.signIn();

      if (userGoogle == null) {
        throw 'No se selecciono ningún correo.';
      }

      String email = userGoogle.email;
      // Verificamos si el usuario ya está registrado.
      Map<String, dynamic>? data = await _userApi.getUserByEmail(email);

      if (data == null) throw 'Este correo no está registrado.';

      _user.fromJson(data);

      // Si lo encontró, entonces también actualizamos el token
      String? token = await FirebaseService().getToken();

      if (token == null) {
        throw "Error al actualizar el token. Intentelo más tarde.";
      }

      data = {
        "token": token,
      };

      await _userApi.updateToken(_user.id!, data);

      _user.token = token;

      // Guardamos en local para abrir sesión cada vez que la app se cierra
      await _storage.save(_user.toJson());
    } catch (error) {
      rethrow;
    } finally {
      await _googleSignIn.signOut();
    }
  }

  @override
  Future<void> logOut() async {
    try {
      // Limpiamos el usuario registrado localmente.
      await _storage.clean();
      _user.clean();
      // Borramos token para dejar de recibir notificaciones.
      FirebaseService().deleteToken();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signIn() async {
    try {
      // Obtenemos el correo seleccionado por el usuario.
      GoogleSignInAccount? userGoogle = await _googleSignIn.signIn();

      if (userGoogle == null) {
        throw 'No se selecciono ningún correo.';
      }

      // Verificamos si no ha sido registrado anteriormente.
      final user = await _userApi.getUserByEmail(userGoogle.email);

      if (user != null) {
        throw 'Este correo ya se encuentra registrado.';
      }

      // Se obtiene los datos base para crear el usuario.
      _user.name = userGoogle.displayName!;
      _user.email = userGoogle.email;
      _user.avatar = userGoogle.photoUrl;
    } catch (e) {
      rethrow;
    } finally {
      await _googleSignIn.signOut();
    }
  }

  Future<void> requestPhone(String phone) async {
    try {
      // Completamos el registro del usuario.
      _user.phone = phone;
      _user.token = await FirebaseService().getToken();

      // Se preparan para poder enviarlos al servidor.
      Map<String, dynamic>? data = _user.toJson();

      data = await _userApi.create(data);

      // Ahora el usuario está registrado.
      _user.fromJson(data!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkUserAuthentication() async {
    final isUserAuthenticated = await _storage.load();

    // NO hay ningún dato guardado de manera local.
    if (isUserAuthenticated == null) return false;

    // Existe, ahora se usara en todo el ciclo de vide de la aplicación.
    _user.fromJson(isUserAuthenticated);

    return true;
  }
}
