import 'package:firebase_messaging/firebase_messaging.dart';

/*
//  Clase abstracta para los eventos en las notificaciones
*/
abstract class NotificationEvent {}

/*
//  Habilita la entrega de notificaciones
*/
class EnabledNotification extends NotificationEvent {}

/*
//  Desahilita la entrega de notificaciones
*/
class DisabledNotification extends NotificationEvent {}

/*
//  Resivir y manajer la notificacion
//  Se requiere un parametro String message que representa el mensaje
*/
class ReceiveNotification extends NotificationEvent {
  RemoteMessage message;

  ReceiveNotification(this.message);
}
