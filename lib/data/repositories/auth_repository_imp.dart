import 'package:alerta_uaz/data/data_sources/remote/google_sign_in_service.dart';
import 'package:alerta_uaz/data/data_sources/remote/user_service.dart';
import 'package:alerta_uaz/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl {
  final GoogleSignInService _googleSignInService;
  final UserService _userService;

  AuthRepositoryImpl(this._googleSignInService, this._userService);

  GoogleSignInAccount? getUserGoogle() {
    return _googleSignInService.getUser();
  }

  Future<GoogleSignInAccount?> logInGoogle() async {
    return await _googleSignInService.signIn();
  }

  Future<void> logOutGoogle() async {
    await _googleSignInService.logOut();
  }

  Future<Map<String, dynamic>?> signInUser(String nameUser, String emailUser,
      String phoneUser, String avatarUserUrl, String deviceToken) async {
    return await _userService.signInUser(
        nameUser, emailUser, phoneUser, avatarUserUrl, deviceToken);
  }
}
