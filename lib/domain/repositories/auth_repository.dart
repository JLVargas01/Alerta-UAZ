import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRepository {
  Future<void> logOutGoogle();
  Future<GoogleSignInAccount?> logInGoogle();
  GoogleSignInAccount? getUserGoogle();
}
