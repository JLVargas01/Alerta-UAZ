abstract class AlertState {}

class AlertInitial extends AlertState {}

class AlertSending extends AlertState {}

class AlertSent extends AlertState {
  final String message;

  AlertSent(this.message);
}

class AlertError extends AlertState {
  final String error;

  AlertError(this.error);
}
