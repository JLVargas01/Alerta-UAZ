import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationEvent {}

class EnabledNotification extends NotificationEvent {}

class DisabledNotification extends NotificationEvent {}

class ReceiveNotification extends NotificationEvent {
  RemoteMessage message;

  ReceiveNotification(this.message);
}
