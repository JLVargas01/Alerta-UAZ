abstract class AlertEvent {}

class EnabledAlert extends AlertEvent {}

class DisabledAlert extends AlertEvent {}

class SendAlert extends AlertEvent {
  final String room;

  SendAlert(this.room);
}

class RegisterAlert extends AlertEvent {}

class ShakeAlert extends AlertEvent {
  final bool isActivated;

  ShakeAlert(this.isActivated);
}

class LoadAlertHistory extends AlertEvent {}
