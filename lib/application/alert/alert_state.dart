import 'package:alerta_uaz/domain/model/alerts_received_model.dart';
import 'package:alerta_uaz/domain/model/alerts_sent_model.dart';

abstract class AlertState {
  final String? message;

  AlertState({this.message});
}

class AlertActivated extends AlertState {}

class AlertDeactivated extends AlertState {}

class AlertLoading extends AlertState {
  AlertLoading({super.message});
}

class AlertLoaded extends AlertState {
  final List<AlertSent>? myAlertHistory;
  final List<AlertReceived>? contactAlertHistory;
  AlertLoaded({super.message, this.myAlertHistory, this.contactAlertHistory});
}

class AlertError extends AlertState {
  final String title;

  AlertError({required super.message, required this.title});
}
