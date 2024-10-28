import 'dart:async';

import 'package:alerta_uaz/application/notification/notification_event.dart';
import 'package:alerta_uaz/application/notification/notification_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FirebaseService _message = FirebaseService();

  NotificationBloc() : super(NotificationInitial()) {
    on<EnabledNotification>(_onStartNotification);
    on<DisabledNotification>(_onStopNotification);
    on<ReceivedNotification>(
        (event, emit) => emit(NotificationReceived(event.message)));
  }

  // Activa la llegada de notificaciones
  Future<void> _onStartNotification(
      NotificationEvent event, Emitter<NotificationState> emit) async {
    await _message.requestPermission();
    await _message.setUpMessages();
    _message.messageController.listen((notification) {
      add(ReceivedNotification(notification));
    });
  }

  // Detiene la llegada de notificaciones
  Future<void> _onStopNotification(
      NotificationEvent event, Emitter<NotificationState> emit) async {
    _message.deleteToken();
  }

//   void _getToken() async {
//     final settings = await _messaging.getNotificationSettings();

//     if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

//     final String? token = await _messaging.getToken();

//     if (token != null) {
//       print('token: ${token}');
//     }
//   }

//   void _onForegroundMessage() {
//     FirebaseMessaging.onMessage.listen(handleRemoteMessage);
//   }

//   void _onBackgroundMessage() {
//     FirebaseMessaging.onBackgroundMessage(handleRemoteMessage);
//   }

//   void _onMessageOpenedApp() {
//     FirebaseMessaging.onMessageOpenedApp.listen(handleRemoteMessage);
//   }
// }

// Future<void> handleRemoteMessage(RemoteMessage message) async {
//   var data = message.data;
//   var title = message.notification!.title;
//   var body = message.notification!.body;

//   print('Llego un mensaje: $title - $body: $data');
}
