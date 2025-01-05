abstract class AlertEvent {}

/// Habilita las funciones de alerta (al ser activada)
/// - Recibir y enviar ubicación en tiempo real
/// - Capturar, enviar y recibir audio en tiempo real
/// - Registrar alertas emitidas
/// - Registrar alertas de contactos
class EnabledAlert extends AlertEvent {}

/// Deshabilita las funciones de alerta
class DisabledAlert extends AlertEvent {}

/// Al activar la alerta realiza lo siguiente:
/// - Se envía notificación a contactos registrados
/// - Envía ubicación en tiempo real (cada 5s actualiza ubicación)
/// - Captura y envía audio en tiempo real
class ActiveAlert extends AlertEvent {}

/// Al desactivar la alerta realiza lo siguiente:
/// - Se envía notificación a contactos registrados
/// - Detiene el envío de ubicación en tiempo real
/// - Detiene captura y el envío de audio en tiempo real
/// - Registra alerta (local y en servidor)
class DesactiveAlert extends AlertEvent {}

/// Cuando recibimos alerta del usuario emisor se realiza lo siguiente:
/// - Obtiene y visualiza la ubicación en tiempo real
/// - Obtiene y reproduce el audio en tiempo real
class ActivatedContactAlert extends AlertEvent {
  final String room;

  ActivatedContactAlert(this.room);
}

///
/// - Detiene la visualización de ubicación en tiempo real
/// - Detiene la reprodución de audio en tiempo real
class DesactivatedContactAlert extends AlertEvent {}

/// Cada vez que el usuario emisor desactiva la alerta se recibira
/// una notificación que contendra datos escenciales para
/// registrar la alerta del usuario emisor.
class RegisterContactAlert extends AlertEvent {
  final Map<String, dynamic> data;

  RegisterContactAlert(this.data);
}

/// Evento que solo actualiza la ubicación en tiempo real del usuario emisor
class ReceivingLocationContactAlert extends AlertEvent {
  dynamic location;

  ReceivingLocationContactAlert(this.location);
}

class ShakeAlert extends AlertEvent {
  final bool isActivated;

  ShakeAlert(this.isActivated);
}

/// Carga el historial del usuario actual y de los contactos
class LoadAlertHistory extends AlertEvent {}
