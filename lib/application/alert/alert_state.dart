import 'package:alerta_uaz/domain/model/contact_alert_model.dart';
import 'package:alerta_uaz/domain/model/my_alert_model.dart';

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
  final List<MyAlert>? myAlertHistory;
  final List<ContactAlert>? contactAlertHistory;

  AlertLoaded({super.message, this.myAlertHistory, this.contactAlertHistory});
}

class AlertError extends AlertState {
  final String title;

  AlertError({required super.message, required this.title});
}
