import 'dart:async';

import 'package:alerta_uaz/data/data_sources/remote/firebase_service.dart';
import 'package:alerta_uaz/domain/model/notification_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationReceived extends NotificationState {
  NotificationMessage message;

  NotificationReceived(this.message);
}

class NotificationError extends NotificationState {
  final String error;

  NotificationError(this.error);
}

abstract class NotificationEvent {}

class Enabled extends NotificationEvent {}

class Disabled extends NotificationEvent {}

class Received extends NotificationEvent {
  NotificationMessage message;

  Received(this.message);
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FirebaseService _message;

  NotificationBloc(this._message) : super(NotificationInitial()) {
    on<Enabled>(_onStartNotification);
    on<Disabled>(_onStopNotification);
    on<Received>(
      (event, emit) {
        emit(NotificationReceived(event.message));
      },
    );
  }

  // Activa la llegada de notificaciones
  Future<void> _onStartNotification(
      NotificationEvent event, Emitter<NotificationState> emit) async {
    await _message.requestPermission();
    await _message.setUpMessages();
    _message.messageController.listen((notification) {
      add(Received(notification));
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
