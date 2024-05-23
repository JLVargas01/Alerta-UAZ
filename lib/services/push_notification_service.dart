import 'dart:async';

import 'package:alerta_uaz/main.dart';
import 'package:alerta_uaz/pages/location_screen.dart';
import 'package:flutter/material.dart';

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

  // Manejador de notificaciones en segundo plano
  static Future _backgroundMessageHandler(RemoteMessage message) async {
    _messageHandle(message);
  }

  // Manejador de notificaciones en primer plano
  static Future _onMessageHandler(RemoteMessage message) async {
    _messageHandle(message);
  }

  // Manejador al interactuar con la notificación
  static Future _onMessageOpenedAppHandler(RemoteMessage message) async {
    _messageHandle(message);
  }

  static void _messageHandle(RemoteMessage message) {
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (_) => const LocationPage()));
  }

  // Inicialización de notificaciones
  static Future<void> initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // await _permissionFCM();
    // getToken();

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedAppHandler);
  }

  static Future<bool> permissionFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
    } else {
      //  El usuario no ha aceptado los persmisos
      return false;
    }
  }

  static Future<String?> getToken() async {
    try {
      final String? token = await _firebaseMessaging.getToken();
      // print('Firebase Messaging Token: $token');
      return token;
    } catch (e) {
      return null;
    }
  }
}
