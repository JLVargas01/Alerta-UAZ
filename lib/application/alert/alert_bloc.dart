import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/alert_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/notification_api.dart';
import 'package:alerta_uaz/data/repositories/alert_repository_impl.dart';
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

    on<ActiveAlert>((event, emit) async {
      emit(AlertLoading(message: 'Iniciando alerta...'));
      String room = _alertRepositoryImp.getRoom;
      _alertRepositoryImp.connectAlert();
      try {
        _alertRepositoryImp.sendAlertActivated(room);
        _alertRepositoryImp.startSendLocation(room);
        _alertRepositoryImp.startSendAudio(room);
        emit(AlertLoaded(message: 'La alerta ha iniciado exitosamente.'));
      } catch (e) {
        emit(
          AlertError(
              message: 'Error al inicializar la alerta: ${e.toString()}',
              title: 'Iniciar Alerta'),
        );
      }
    });

    on<DesactiveAlert>(
      (event, emit) async {
        emit(AlertLoading(message: 'Desactivando alerta...'));
        try {
          _alertRepositoryImp.disconnectAlert();
          _alertRepositoryImp.stopSendLocation();
          _alertRepositoryImp.stopSendAudio();

          // Se obtiene los datos necesarios para registrar la alerta
          Map<String, dynamic> data = await _alertRepositoryImp.saveAlert();
          _alertRepositoryImp.registerServerMyAlert(data);
          _alertRepositoryImp.registerLocalMyAlert(data);

          /// Se les notifica a los contactos que la alerta ha finalizado y
          /// se les enviará los últimos datos del usuario emisor
          _alertRepositoryImp.sendAlertDesactivated(data);
          emit(AlertLoaded(message: 'Alerta desactivada exitosamente.'));
        } catch (e) {
          emit(
            AlertError(
                message: 'Error al desactivar la alerta: ${e.toString()}',
                title: 'Desactivar alerta'),
          );
        }
      },
    );

    on<ActivatedContactAlert>(
      (event, emit) {
        emit(AlertLoading(message: 'Estableciendo conexión...'));
        String room = event.room;

        receivedLocationHanlder(dynamic location) {
          add(ReceivingLocationContactAlert(location));
        }

        try {
          _alertRepositoryImp.connectAlert();
          _alertRepositoryImp.joinRoomAlert(room);
          _alertRepositoryImp.startReceivedLocation(receivedLocationHanlder);
          _alertRepositoryImp.startPlayAudio();
          emit(AlertLoaded(message: 'Conexión exitosa.'));
        } catch (e) {
          emit(AlertError(
              message: 'Error en alerta activada: ${e.toString()}',
              title: 'Contacto Alerta'));
        }
      },
    );

    on<DesactivatedContactAlert>(
      (event, emit) {
        emit(AlertLoading(message: 'Realizando desconexión...'));
        try {
          _alertRepositoryImp.disconnectAlert();
          _alertRepositoryImp.stopPlayAudio();
          emit(AlertLoaded(message: 'Desconexión exitosa.'));
        } catch (e) {
          emit(AlertError(
              message: 'Error en alerta desactivada: ${e.toString()}',
              title: 'Contacto Alerta'));
        }
      },
    );

    on<RegisterContactAlert>(
      (event, emit) {
        emit(AlertLoading(message: 'Registrando alerta del contacto...'));
        Map<String, dynamic> data = event.data;
        try {
          _alertRepositoryImp.registerLocalContactAlert(data);
          emit(AlertLoaded(message: 'Alerta del contacto registrada.'));
        } catch (e) {
          emit(AlertError(message: e.toString(), title: 'Registrar Alerta'));
        }
      },
    );

    on<ReceivingLocationContactAlert>(
      (event, emit) => emit(AlertReceivedLocation(event.location)),
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
          final myHistory = await _alertRepositoryImp.loadMyAlertHistory();
          final contactHistory =
              await _alertRepositoryImp.loadContactsAlertHistory();

          emit(AlertLoadedHistory(myHistory, contactHistory));
        } catch (e) {
          emit(AlertError(
              message: 'Error al cargar el historial: ${e.toString()}',
              title: 'Historial'));
        }
      },
    );
  }
}
