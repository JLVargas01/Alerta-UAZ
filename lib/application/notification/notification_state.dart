import 'package:alerta_uaz/domain/model/notification_model.dart';

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
