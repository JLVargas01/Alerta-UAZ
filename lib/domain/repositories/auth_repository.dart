import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRepository {
  Future<void> logOutGoogle();
  Future<GoogleSignInAccount?> logInGoogle();
  GoogleSignInAccount? getUserGoogle();
  Future<User?> signInUser(User user);
}
