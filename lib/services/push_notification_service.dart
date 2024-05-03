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
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);

      await _permissionFCM();

      getToken();

      // Handlers
      FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
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
