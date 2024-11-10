import 'package:alerta_uaz/domain/model/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationAlert extends StatelessWidget {
  final NotificationMessage message;

  const NotificationAlert({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final notification = message.notification;

    return AlertDialog(
      title: Text(notification?.title ?? 'Notificación'),
      content: Text(notification?.body ?? 'No hay contenido disposible'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed('/map',
                    arguments: message.data!['room']);
              });
            },
            child: const Text('ver ubicación')),
      ],
    );
  }
}
