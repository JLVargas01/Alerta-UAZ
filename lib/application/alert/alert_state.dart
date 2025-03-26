import 'dart:io';
import 'package:alerta_uaz/domain/model/contact_alert_model.dart';
import 'package:alerta_uaz/domain/model/my_alert_model.dart';
import 'package:equatable/equatable.dart';

/*
//  Clase abstracta para los estados en las alertas
//  Es posible enviar un parametro opcional de tipo String que representa un mensaje
*/
abstract class AlertState extends Equatable {
  final String? message;

  const AlertState({this.message});

  @override
  List<Object?> get props => [message];
}

/*
//  Indicador que representa la emision de la alerta
*/
class AlertActivated extends AlertState {}

/*
//  Indicador que represena la terminacion de la alerta
*/
class AlertDeactivated extends AlertState {}

/*
//  Indicacion para mostrar una pantalla de carga, relacionado con las alertas
//  Se requiere un parametro de tipor String que representa el mensaje a mostrar
*/
class AlertLoading extends AlertState {
  const AlertLoading({super.message});

  @override
  List<Object?> get props => [message];
}

/*
//  Indica que se ha terminado de cargar datos, relacionado con las alertas
//  Se requiere un parametro de tipor String que representa el mensaje a mostrar
*/
class AlertLoaded extends AlertState {
  const AlertLoaded({super.message});

  @override
  List<Object?> get props => [message];
}

/*
//  Indica que se ha terminado de cargar el historial de alertas
//  Se requiere los siguientes parametros:
// - Una lista de objetos tipo MyAlert, contiene el historial de alertas
//  emitidas por el usuario
//.- Una lista de objetos tipo ContactAlert, contiene el historial de alertas
//  resividas de otros usuarios
*/
class AlertLoadedHistory extends AlertState {
  final List<MyAlert> myAlertHistory;
  final List<ContactAlert> contactAlertHistory;

  const AlertLoadedHistory(this.myAlertHistory, this.contactAlertHistory);

  @override
  List<Object?> get props => [myAlertHistory, contactAlertHistory];
}

/*
//  Indica que se ha cargado en el mapa la posición del usuario que activó la alerta
//  Se requiere un parametro de tipor dynamic que representa las cordenadas
*/
class AlertReceivedLocation extends AlertState {
  final dynamic location;

  const AlertReceivedLocation(this.location);

  @override
  List<Object?> get props => [location];
}

/*
//  Indica que el audio existe
*/
class AlertAudioExists extends AlertState {}

/*
//  Indica que el audio no existe
//  Se requiere un parametro de tipor String que representa el mensaje a mostrar
*/
class AlertAudioNotExists extends AlertState {
  const AlertAudioNotExists({super.message});

  @override
  List<Object?> get props => [message];
}

/*
//  Indica que el audio se descarga del servidor
//  Se requiere un parametro de tipor String que representa el mensaje a mostrar
*/
class AlertAudioDownloaded extends AlertState {
  final File audio;

  const AlertAudioDownloaded(this.audio);

  @override
  List<Object?> get props => [audio];
}

/*
//  Indica que ha ocurrido un error relacionado con las alertas
//  Se requiere los siguientes parametro 
// -De tipor String message que representa el mensaje a mostrar
// -De tipor String title que representa el encabezado a mostrar
*/
class AlertError extends AlertState {
  final String title;

  const AlertError({required super.message, required this.title});

  @override
  List<Object?> get props => [message, title];
}
