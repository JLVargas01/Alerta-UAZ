import 'package:alerta_uaz/data/data_sources/remote/google_sign_in_service.dart';
import 'package:alerta_uaz/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignInService _googleSignInService;

  AuthRepositoryImpl(this._googleSignInService);

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
}
