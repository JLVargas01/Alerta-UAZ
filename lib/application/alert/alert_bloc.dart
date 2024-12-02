import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/alert_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/notification_api.dart';
import 'package:alerta_uaz/data/repositories/alert_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final _alertRepositoryImp =
      AlertRepositoryImpl(NotificationApi(), AlertApi());

  AlertBloc() : super(AlertInitial()) {
    on<EnabledAlert>(
      (event, emit) {
        _alertRepositoryImp.startAlert(() {
          add(ShakeAlert(true));
        });
      },
    );

    on<DisabledAlert>(
      (event, emit) {
        _alertRepositoryImp.stopAlert();
      },
    );

    on<SendAlert>(
      (event, emit) async {
        emit(AlertLoading(message: 'Enviando notificación a contactos....'));
        String room = event.room;
        try {
          await _alertRepositoryImp.sendAlert(room);
          emit(AlertSent(message: 'La alerta fue envíada exitosamente.'));
        } catch (e) {
          emit(AlertError(message: e.toString(), title: 'notificación'));
        }
      },
    );

    on<RegisterAlert>(
      (event, emit) async {
        emit(AlertLoading(message: 'Registrando alerta...'));
        try {
          await _alertRepositoryImp.registerAlert();
          emit(AlertRegistered(message: 'Alerta registrada exitosamente.'));
        } catch (e) {
          emit(AlertError(message: e.toString(), title: 'alerta'));
        }
      },
    );

    on<ShakeAlert>(
      (event, emit) {
        if (event.isActivated) {
          _alertRepositoryImp.pauseAlert();
          emit(AlertActivated());
        } else {
          _alertRepositoryImp.resumeAlert();
          emit(AlertDeactivated());
        }
      },
    );
  }
}
