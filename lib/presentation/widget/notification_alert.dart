import 'package:alerta_uaz/domain/model/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationAlert extends StatelessWidget {
  final NotificationModel notificationModel;

  const NotificationAlert({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    final notification = notificationModel.notification;

    return AlertDialog(
      title: Text(notification?.title ?? 'Notificación'),
      content: Text(notification?.body ?? 'No hay contenido disposible'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed('/map',
                    arguments: notificationModel.data);
              });
            },
            child: const Text('ver ubicación')),
      ],
    );
  }
}
