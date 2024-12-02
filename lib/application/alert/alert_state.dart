abstract class AlertState {
  final String? message;

  AlertState({this.message});
}

class AlertInitial extends AlertState {}

class AlertLoading extends AlertState {
  AlertLoading({required super.message});
}

class AlertSent extends AlertState {
  AlertSent({required super.message});
}

class AlertRegistered extends AlertState {
  AlertRegistered({required super.message});
}

class AlertActivated extends AlertState {}

class AlertDeactivated extends AlertState {}

class AlertError extends AlertState {
  final String title;

  AlertError({required super.message, required this.title});
}
