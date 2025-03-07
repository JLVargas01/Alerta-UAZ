import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/*
//  Clase abstracta para los eventos de los contactos
//  Es posible enviar un parametro opcional de tipo String que representa un mensaje
*/
abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

/*
//  Estado inicial para las notificaciones
*/
class NotificationInitial extends NotificationState {}

/*
//  Estado para mostrar la notificación recibida.
//  Se requiere un parametro de tipo RemoteMessage message, siendo la notificacion
*/
class NotificationReceived extends NotificationState {
  final RemoteMessage message;

  NotificationReceived(this.message);

  @override
  List<Object?> get props => [message];
}

/*
//  Estado para indicar un error relacionado con las notifaciones
*/
class NotificationError extends NotificationState {
  final String error;

  NotificationError(this.error);
}
