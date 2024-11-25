import 'package:alerta_uaz/data/data_sources/remote/google_sign_in_service.dart';
import 'package:alerta_uaz/data/data_sources/remote/user_service.dart';
import 'package:alerta_uaz/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignInService _googleSignInService;
  final UserService _userService;

  AuthRepositoryImpl(this._googleSignInService, this._userService);

  @override
  GoogleSignInAccount? getUserGoogle() {
    return _googleSignInService.getUser();
  }

  @override
  Future<GoogleSignInAccount?> logInGoogle() async {
    return await _googleSignInService.logIn();
  }

  @override
  Future<void> logOutGoogle() async {
    await _googleSignInService.logOut();
  }

  Future<Map<String, dynamic>> signInUser(String nameUser, String emailUser,
      String phoneUser, String avatarUserUrl, String deviceToken) async {
    return await _userService.signInUser( nameUser, emailUser, phoneUser, avatarUserUrl, deviceToken);
  }

  Future<Map<String, dynamic>?> getDataUserByEmail(String emailUser) async {
    return await _userService.findUserByEmail(emailUser);
  }
}
