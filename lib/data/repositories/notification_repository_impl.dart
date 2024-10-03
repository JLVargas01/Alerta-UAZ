import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

import '../data_sources/remote/firebase_messaging_service.dart';
import '../../domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationRepository {
  final FirebaseMessagingService _firebaseMessagingService;

  final String? protocol = dotenv.env['PROTOCOL'];
  final String? hostname = dotenv.env['HOST_NAME'];
  final String? port = dotenv.env['PORT_NOTIFICATION'];

  String? _baseURL;

  NotificationsRepositoryImpl(this._firebaseMessagingService) {
    if (protocol == null || hostname == null || port == null) {
      throw Exception(
          'Error: Asegúrate de que PROTOCOL, HOST_NAME y PORT_NOTIFICATION están definidos.');
    }
    _baseURL = '$protocol://$hostname:$port';
  }

  @override
  Stream<RemoteMessage> getNotificationStream() {
    return _firebaseMessagingService.notificationStream;
  }

  @override
  Future<void> initialize() async {
    await _firebaseMessagingService.initialize();
  }

  @override
  Future<bool> requestPermission() async {
    return await _firebaseMessagingService.requestPermission();
  }

  @override
  Future<String?> getDeviceToken() async {
    return await _firebaseMessagingService.getDeviceToken();
  }

  @override
  Future<void> deleteDeviceToken() async {
    await _firebaseMessagingService.deleteDeviceToken();
  }

  Future<void> notificationAlert() async {
    // Lógica para enviar notificaciones de alerta a contactos
    const endponint = '';
    Map<String, Object> data = {};
    return await _sendNotification(endponint, data);
  }

  Future<void> _sendNotification(
      String endpoint, Map<String, Object> data) async {
    if (_baseURL == null) {
      throw Exception('Error: Base URL no está configurada correctamente.');
    }

    final url = Uri.parse(_baseURL! + endpoint);

    try {
      final response = await http.post(
        url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Error al enviar los datos $endpoint: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al enviar la notificación: $e');
    }
  }
}
