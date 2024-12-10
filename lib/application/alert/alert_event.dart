abstract class AlertEvent {}

class EnabledAlert extends AlertEvent {}

class DisabledAlert extends AlertEvent {}

class SendAlert extends AlertEvent {
  final String room;

  SendAlert(this.room);
}

class RegisterMyAlert extends AlertEvent {}

class RegisterContactAlert extends AlertEvent {
  final Map<String, dynamic> contactAlertData;

  RegisterContactAlert(this.contactAlertData);
}

class ShakeAlert extends AlertEvent {
  final bool isActivated;

  ShakeAlert(this.isActivated);
}

class LoadAlertHistory extends AlertEvent {}
