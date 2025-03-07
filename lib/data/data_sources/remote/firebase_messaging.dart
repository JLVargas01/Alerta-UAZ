import 'dart:async';
import 'package:alerta_uaz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Servicio para gestionar las notificaciones push mediante Firebase Cloud Messaging (FCM).
/// Proporciona métodos para inicializar Firebase, solicitar permisos, manejar tokens y recibir notificaciones.
class FirebaseMessagingService {
  /// Instancia de FirebaseMessaging para gestionar notificaciones push.
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// StreamController para manejar las notificaciones entrantes en tiempo real.
  static late StreamController<RemoteMessage> _streamController;

  /// Stream público para suscribirse a las notificaciones recibidas.
  static Stream<RemoteMessage> get stream => _streamController.stream;

  /// Inicializa Firebase en la aplicación.
  /// Este método debe llamarse antes de utilizar cualquier funcionalidad de Firebase.
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /// Solicita permisos de notificación al usuario.
  /// Configura los permisos de alerta, sonido, insignias y otros parámetros.
  static Future<void> requestPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  /// Verifica si el usuario ha otorgado permisos para recibir notificaciones.
  /// Retorna 'true' si las notificaciones están autorizadas, `false` en caso contrario.
  static Future<bool> statusPermission() async {
    final status = await messaging.getNotificationSettings();

    return status.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Configura la recepción de notificaciones en la aplicación.
  /// - Inicializa el `StreamController` para transmitir mensajes.
  /// - Escucha notificaciones recibidas cuando la app está en primer plano.
  /// - Escucha notificaciones que abren la app desde una notificación.
  static void setUp() async {
    _streamController = StreamController<RemoteMessage>.broadcast();
    FirebaseMessaging.onMessage.listen(_handle);
    FirebaseMessaging.onMessageOpenedApp.listen(_handle);
  }

  /// Maneja la recepción de un mensaje y lo añade al Stream.
  /// [message] - Mensaje de tipo `RemoteMessage` recibido desde FCM.
  static void _handle(RemoteMessage message) {
    _streamController.add(message);
  }

  /// Obtiene el token FCM del dispositivo.
  /// Retorna un 'String?' con el token del dispositivo, o `null` si no está disponible.
  static Future<String?> getToken() async {
    return await messaging.getToken();
  }

  /// Elimina el token FCM del dispositivo.
  /// Esto evita que el dispositivo reciba notificaciones push hasta que se genere un nuevo token.
  static void deleteToken() async {
    await messaging.deleteToken();
  }

  /// Escucha la renovación del token FCM del dispositivo.
  /// [handler] - Función de devolución de llamada que se ejecutará cuando se genere un nuevo token.
  static void refreshToken(Function handler) async {
    messaging.onTokenRefresh.listen((newToken) => handler(newToken));
  }

  /// Cierra el `StreamController` de notificaciones.
  /// Este método debe llamarse cuando ya no se necesite recibir notificaciones.
  static void streamClose() {
    _streamController.close();
  }
}
