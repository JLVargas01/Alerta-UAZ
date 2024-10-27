import 'package:alerta_uaz/data/data_sources/remote/notification_service.dart';
import 'package:alerta_uaz/data/data_sources/remote/shake_detector_service.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AlertState {}

class AlertInitial extends AlertState {}

class AlertSending extends AlertState {}

class AlertSent extends AlertState {
  final String success;

  AlertSent(this.success);
}

class AlertError extends AlertState {
  final String error;

  AlertError(this.error);
}

abstract class AlertEvent {}

class AlertEnabled extends AlertEvent {
  final User user;

  AlertEnabled(this.user);
}

class _AlertSending extends AlertEvent {}

class AlertDisabled extends AlertEvent {}

class _AlertSent extends AlertEvent {
  final String success;

  _AlertSent(this.success);
}

class _AlertError extends AlertEvent {
  final String error;

  _AlertError(this.error);
}

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final ShakeDetectorService _shakeDetectorService = ShakeDetectorService();
  final NotificationService _notificationService = NotificationService();

  AlertBloc() : super(AlertInitial()) {
    on<AlertEnabled>(_startListeningShake);
    on<AlertDisabled>(_stopListeningShake);
    on<_AlertSending>((event, emit) => emit(AlertSending()));
    on<_AlertSent>((event, emit) => emit(AlertSent(event.success)));
    on<_AlertError>((event, emit) => emit(AlertError(event.error)));
    resumeListeningShake();
  }

  Future<void> _startListeningShake(
      AlertEnabled event, Emitter<AlertState> emit) async {
    if (!_shakeDetectorService.isListening) {
      User user = event.user;
      // Marcar el detector como escuchando
      _shakeDetectorService.startListening(() async {
        _shakeDetectorService.pauseListening();

        add(_AlertSending());
        try {
          // Lógica para enviar notificaciones de alerta.
          String idRoom = '${DateTime.now()}:${user.name}'.replaceAll(' ', '');
          String idContact = user.idContacts!;

          // Preparando datos
          Map<String, dynamic> data = {
            'id_room': idRoom,
            'name': user.name,
            'avatar': user.avatar
          };

          // Enviar alerta
          final success =
              await _notificationService.notificationAlert(idContact, data);

          // Emitir estado de alerta enviada
          add(_AlertSent(success));
        } catch (error) {
          add(_AlertError(error.toString()));
        } finally {
          _shakeDetectorService.resumeListening();
        }
      });
    }
  }

  Future<void> _stopListeningShake(
      AlertEvent event, Emitter<AlertState> emit) async {
    _shakeDetectorService.stopListening();
  }

  void resumeListeningShake() {
    if (_shakeDetectorService.isPaused) {
      _shakeDetectorService.resumeListening();
    }
  }
}
