import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/*
//  Clase abstracta para los eventos en las notificaciones
*/
abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

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
  final RemoteMessage message;

  ReceiveNotification(this.message);

  @override
  List<Object?> get props => [message];
}
