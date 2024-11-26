import 'package:alerta_uaz/data/data_sources/local/storage.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRepository {
  Future<void> logOutGoogle();
  Future<GoogleSignInAccount?> logInGoogle();
  GoogleSignInAccount? getUserGoogle();
  //User user = User();
  //Storage storage = Storage('user');

  //Future<void> signIn(String phone);
  //Future<void> logIn(String? email);
  //Future<void> logOut();

  //Future<bool> checkUserAuthentication() async {
    //final isUserAuthenticated = await storage.load();

    // NO hay ningún dato guardado de manera local.
    //if (isUserAuthenticated == null) return false;

    // Existe, ahora se usara en todo el ciclo de vide de la aplicación.
    //user.fromJson(isUserAuthenticated);

    //return true;
  //}
}
