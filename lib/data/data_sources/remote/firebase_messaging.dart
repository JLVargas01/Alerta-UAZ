/*
// Toda esta clase, por revisar
//  $ComentarioPorRevisar
*/

import 'dart:async';

import 'package:alerta_uaz/firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Comparte de manera externa las notificaciones que vaya recibiendo.
  static late StreamController<RemoteMessage> _streamController;
  static Stream<RemoteMessage> get stream => _streamController.stream;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

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

  static Future<bool> statusPermission() async {
    final status = await messaging.getNotificationSettings();

    return status.authorizationStatus == AuthorizationStatus.authorized;
  }

  static void setUp() async {
    _streamController = StreamController<RemoteMessage>.broadcast();

    FirebaseMessaging.onMessage.listen(_handle);
    FirebaseMessaging.onMessageOpenedApp.listen(_handle);
  }

  static void _handle(RemoteMessage message) {
    _streamController.add(message);
  }

  static Future<String?> getToken() async {
    return await messaging.getToken();
  }

  static void deleteToken() async {
    await messaging.deleteToken();
  }

  static void refreshToken(Function handler) async {
    messaging.onTokenRefresh.listen((newToken) => handler);
  }

  static void streamClose() {
    _streamController.close();
  }
}
