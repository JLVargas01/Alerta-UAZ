import 'dart:async';

import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final PushNotificationService _instance =
      PushNotificationService._internal();

  factory PushNotificationService() {
    return _instance;
  }

  PushNotificationService._internal();

  // Manejador de notificaciones en primer plano
  static Future _onMessageHandler(RemoteMessage message) async {
    _messageHandle(message);
  }

  // Manejador al interactuar con la notificación
  static Future _onMessageOpenedAppHandler(RemoteMessage message) async {
    _messageHandle(message);
  }

  static void _messageHandle(RemoteMessage message) {
    print('Se obtuvo notificación');
  }

  // Inicialización de notificaciones
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);

      await _permissionFCM();

      getToken();

      // Handlers
      FirebaseMessaging.onMessage.listen(_onMessageHandler);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedAppHandler);
    } catch (e) {
      print('Failed to initialize Firebase: $e');
    }
  }

  static Future<void> _permissionFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true, provisional: false);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static Future<String?> getToken() async {
    try {
      final String? token = await _firebaseMessaging.getToken();
      print('Firebase Messaging Token: $token');
      return token;
    } catch (e) {
      print('Error fetching FCM token: $e');
      return null;
    }
  }
}
