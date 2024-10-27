import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/notification_service.dart';
import 'package:alerta_uaz/data/data_sources/remote/shake_detector_service.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final ShakeDetectorService _shakeDetectorService = ShakeDetectorService();
  final NotificationService _notificationService = NotificationService();

  AlertBloc() : super(AlertInitial()) {
    on<EnabledAlert>(_startListeningShake);
    on<DisabledAlert>(_stopListeningShake);
    on<SendingAlert>((event, emit) => emit(AlertSending()));
    on<SentAlert>((event, emit) => emit(AlertSent(event.success)));
    on<ErrorAlert>((event, emit) => emit(AlertError(event.error)));
    resumeListeningShake();
  }

  Future<void> _startListeningShake(
      EnabledAlert event, Emitter<AlertState> emit) async {
    if (!_shakeDetectorService.isListening) {
      User user = event.user;
      // Marcar el detector como escuchando
      _shakeDetectorService.startListening(() async {
        _shakeDetectorService.pauseListening();

        add(SendingAlert());
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
          add(SentAlert(success));
        } catch (error) {
          add(ErrorAlert(error.toString()));
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
