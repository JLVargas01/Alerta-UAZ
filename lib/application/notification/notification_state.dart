import 'package:firebase_messaging/firebase_messaging.dart';

/*
//  Clase abstracta para los eventos de los contactos
//  Es posible enviar un parametro opcional de tipo String que representa un mensaje
*/
abstract class NotificationState {}

/*
//  Ni idea :(
//  $ComentarioPorRevisar
*/
class NotificationInitial extends NotificationState {}

/*
//  Estado para mostrar la notificación recibida.
//  Se requiere un parametro de tipo RemoteMessage message, siendo la notificacion
*/
class NotificationReceived extends NotificationState {
  RemoteMessage message;

  NotificationReceived(this.message);
}

/*
//  Estado para indicar un error relacionado con las notifaciones
*/
class NotificationError extends NotificationState {
  final String error;

  NotificationError(this.error);
}
