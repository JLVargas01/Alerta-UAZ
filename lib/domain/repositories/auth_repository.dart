abstract class AuthRepository {
  Future<void> signIn();
  Future<void> logIn();
  Future<void> logOut();
  Future<bool> checkUserAuthentication();
}
