import 'package:alerta_uaz/domain/model/notification_model.dart';

abstract class NotificationEvent {}

class EnabledNotification extends NotificationEvent {}

class DisabledNotification extends NotificationEvent {}

class ReceivedNotification extends NotificationEvent {
  NotificationMessage message;

  ReceivedNotification(this.message);
}
