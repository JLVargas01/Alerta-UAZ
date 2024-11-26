import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<GoogleSignInAccount?> signIn() => _googleSignIn.signIn();

  Future<void> logOut() => _googleSignIn.disconnect();

  GoogleSignInAccount? getUser() => _googleSignIn.currentUser;
}
