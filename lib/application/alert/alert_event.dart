import 'package:alerta_uaz/domain/model/user_model.dart';

abstract class AlertEvent {}

class EnabledAlert extends AlertEvent {
  final User user;

  EnabledAlert(this.user);
}

class DisabledAlert extends AlertEvent {}

class SendAlert extends AlertEvent {
  final String room;

  SendAlert(this.room);
}

class RegisterAlert extends AlertEvent {}
