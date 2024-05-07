import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {

  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> logIn() => _googleSignIn.signIn();

  static Future<void> logOut() => _googleSignIn.disconnect();

  static GoogleSignInAccount? getUser() => _googleSignIn.currentUser;

}
