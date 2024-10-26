import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationModel {
  final RemoteNotification? _notification;
  final Map<String, dynamic>? _data;

  NotificationModel(
      {RemoteNotification? notification, Map<String, dynamic>? data})
      : _notification = notification,
        _data = data;

  RemoteNotification? get notification => _notification;
  Map<String, dynamic>? get data => _data;
}
