import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationReceived extends NotificationState {
  RemoteMessage message;

  NotificationReceived(this.message);
}

class NotificationError extends NotificationState {
  final String error;

  NotificationError(this.error);
}
