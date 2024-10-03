import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:alerta_uaz/firebase_options.dart';

class FirebaseMessagingService {
  // Instancia del singleton
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseMessagingService._internal() {
    _configureFirebase();
  }

  // Factory constructor para devolver siempre la misma instancia
  factory FirebaseMessagingService() {
    return _instance;
  }

  void _configureFirebase() async {
    // Maneja notificaciones en segundo plano
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Maneja notificaciones en primer plano
    FirebaseMessaging.onMessage.listen(_handleMessage);

    // Maneja notificaciones cuando se abre la app desde la notificación (en segundo plano)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Maneja mensajes si la app se abre desde estado cerrado
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  Future<void> initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  Future<bool> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> deleteDeviceToken() async {
    await _firebaseMessaging.deleteToken();
  }

  Stream<RemoteMessage> get notificationStream => FirebaseMessaging.onMessage;

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Mensaje recibido en segundo plano: ${message.notification?.title}');
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    print('Mensaje recibido: ${message.notification?.title}');
  }
}
