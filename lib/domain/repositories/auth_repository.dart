/// Define un contrato para la autenticación de usuarios.
/// Esta clase es una abstracción que debe ser implementada por clases concretas 
/// que manejen la autenticación con distintos proveedores
abstract class AuthRepository {
  /// Inicia sesión del usuario.
  /// Este método debe ser implementado para manejar el proceso de autenticación.
  /// [return] Un 'Future' que representa el proceso de inicio de sesión.
  Future<void> signIn();

  /// Cierra la sesión del usuario.
  /// Debe manejar la eliminación de datos de sesión y la desconexión del usuario.
  /// [return] Un 'Future' que representa el proceso de cierre de sesión.
  Future<void> signOut();

  /// Verifica si hay una sesión de usuario activa.
  /// Este método debe retornar información sobre si el usuario ya está autenticado o no.
  /// [return] Un 'Future' que representa la validación del estado de autenticación.
  Future<void> checkUserAuthentication();
}
