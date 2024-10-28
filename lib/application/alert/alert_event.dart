import 'package:alerta_uaz/domain/model/user_model.dart';

abstract class AlertEvent {}

class EnabledAlert extends AlertEvent {
  final User user;

  EnabledAlert(this.user);
}

class DisabledAlert extends AlertEvent {}

class SendingAlert extends AlertEvent {}

class SentAlert extends AlertEvent {
  final String success;

  SentAlert(this.success);
}

class ErrorAlert extends AlertEvent {
  final String error;

  ErrorAlert(this.error);
}
