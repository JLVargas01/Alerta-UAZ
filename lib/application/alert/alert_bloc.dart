import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/alert_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/notification_api.dart';
import 'package:alerta_uaz/data/repositories/alert_repository_impl.dart';
import 'package:alerta_uaz/domain/model/alerts_received_model.dart';
import 'package:alerta_uaz/domain/model/alerts_sent_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final _alertRepositoryImp =
      AlertRepositoryImpl(NotificationApi(), AlertApi());

  AlertBloc() : super(AlertDeactivated()) {
    on<EnabledAlert>(
      (event, emit) {
        _alertRepositoryImp.startAlert(() {
          add(ShakeAlert(true));
        });
      },
    );

    on<DisabledAlert>((event, emit) => _alertRepositoryImp.stopAlert());

    on<SendAlert>(
      (event, emit) async {
        emit(AlertLoading(message: 'Enviando notificación a contactos....'));
        String room = event.room;
        try {
          await _alertRepositoryImp.sendAlert(room);
          emit(AlertMessage(message: 'La alerta fue envíada exitosamente.'));
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
          add(LoadAlertHistory()); // Actualizamos las listas de alerta.
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

    on<LoadAlertHistory>(
      (event, emit) async {
        emit(AlertLoading());

        try {
          List<AlertSent> myAlertHistory = await _alertRepositoryImp.loadMyAlertHistory();
          List<AlertReceived> contactAlertHistory = await _alertRepositoryImp.loadContactsAlertHistory();
          emit(AlertLoaded(myAlertHistory: myAlertHistory,contactAlertHistory: contactAlertHistory));

        } catch (e) {
          emit(AlertError(message: e.toString(), title: 'historial'));
        }
      },
    );
  }
}
