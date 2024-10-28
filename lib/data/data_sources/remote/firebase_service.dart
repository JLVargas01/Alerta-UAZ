import 'dart:async';
import 'package:alerta_uaz/domain/model/notification_model.dart';
import 'package:alerta_uaz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  FirebaseService._internal();

  factory FirebaseService() => _instance;

  late FirebaseMessaging _firebaseMessaging;

  late StreamController<NotificationMessage> _messageController;

  Stream<NotificationMessage> get messageController =>
      _messageController.stream;

  Future<void> initializeApp() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _firebaseMessaging = FirebaseMessaging.instance;

      await requestPermission();
    } catch (e) {
      throw Exception('Error al inicializar Firebase: $e');
    }
  }

  Future<bool> requestPermission() async {
    try {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        // throw Exception('Permisos de notificación denegados');
        return false;
      }
      return true;
    } catch (e) {
      throw Exception('Error al solicitar permisos de notificación: $e');
    }
  }

  Future<void> setUpMessages() async {
    _messageController = StreamController<NotificationMessage>.broadcast();

    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // RemoteMessage? initialMessage =
    //     await _firebaseMessaging.getInitialMessage();
    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);
    //}
  }

  void _handleMessage(RemoteMessage message) {
    NotificationMessage notificationMessage = NotificationMessage(
        notification: message.notification, data: message.data);
    _messageController.add(notificationMessage);
  }

  Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }
      return token;
    } catch (e) {
      throw Exception('Error al obtener el token: $e');
    }
  }

  void deleteToken() async {
    _firebaseMessaging.deleteToken();
    _messageController.close();
  }

  void dispose() {
    _messageController.close();
  }
}
