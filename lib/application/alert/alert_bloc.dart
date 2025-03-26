import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/alert_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/notification_api.dart';
import 'package:alerta_uaz/data/repositories/alert_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
//
//  Clase para manejar las alertas
//  _alertRepositoryImp: Variable final para realizar los distintos
//  metodos de comunicacion hacia la API.
//
*/
class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final _alertRepositoryImp =
      AlertRepositoryImpl(NotificationApi(), AlertApi());

  AlertBloc() : super(AlertDeactivated()) {
    /*
  //  Activar el envio de alertas.
  */
    on<EnabledAlert>(
      (event, emit) {
        _alertRepositoryImp.startAlert(() {
          add(AlertDetector(true));
        });
      },
    );

    /*
    //  Detener el envio de alertas.
    */
    on<DisabledAlert>((event, emit) => _alertRepositoryImp.stopAlert());

    /*
    //  Iniciar el envio de la alerta, capturar audio y enviar locacion.
    //  Muestra mensaje de inicio de alerta o en caso de error, un mensaje que lo indica
    */
    on<ActiveAlert>((event, emit) async {
      emit(AlertLoading(message: 'Iniciando alerta...'));
      await Future.delayed(const Duration(milliseconds: 100));
      String room = _alertRepositoryImp.getRoom;
      _alertRepositoryImp.connectAlert();
      try {
        _alertRepositoryImp.startAudioCapture();
        _alertRepositoryImp.startSendLocation(room);
        final message = await _alertRepositoryImp.sendAlertActivated(room);
        emit(AlertLoaded(message: message));
      } catch (e) {
        emit(
          AlertError(message: e.toString(), title: 'Iniciar Alerta'),
        );
      }
    });

    /*
    //  Detener el envio de la alerta ya activada, detener la captura de audio,
    //  registrar en el dispositivo y en el servidor la alerta emitida y
    //  notificar a los contactos "de confianza" la terminacion de la alerta.
    //  Muestra mensaje de desactivado de alerta o en caso de error, un mensaje que lo indica
    */
    on<DesactiveAlert>(
      (event, emit) async {
        emit(AlertLoading(message: 'Desactivando alerta.'));
        try {
          _alertRepositoryImp.disconnectAlert();
          _alertRepositoryImp.stopSendLocation();

          final path = await _alertRepositoryImp.stopAudioCapture();

          // Se obtiene los datos necesarios para registrar la alerta
          Map<String, dynamic> data = await _alertRepositoryImp.saveAlert(path);
          _alertRepositoryImp.registerLocalMyAlert(data);
          _alertRepositoryImp.registerServerMyAlert(data, path);

          /// Se les notifica a los contactos que la alerta ha finalizado y
          /// se les enviará los últimos datos del usuario emisor
          _alertRepositoryImp.sendAlertDesactivated(data);
          // emit(AlertLoaded(message: 'Alerta desactivada exitosamente.'));
        } catch (e) {
          emit(
            AlertError(message: e.toString(), title: 'Desactivar alerta'),
          );
        }
      },
    );

    /*
    //  Establecer conexion con el usuario que activo la alerta,
    //  unirse a la sala y comenzar a resivir las cordenadas
    */
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
        } catch (e) {
          emit(AlertError(message: e.toString(), title: 'Contacto Alerta'));
        }
      },
    );

    /*
    // Cerrar la conexion con el contacto que inicio la alerta.
    //  Muestra mensaje sobre el estado de la conexion o en caso de error, un mensaje que lo indica
    */
    on<DesactivatedContactAlert>(
      (event, emit) {
        emit(AlertLoading(message: 'Realizando desconexión...'));
        try {
          _alertRepositoryImp.disconnectAlert();
          emit(AlertLoaded(message: 'Desconexión exitosa.'));
        } catch (e) {
          emit(AlertError(message: e.toString(), title: 'Contacto Alerta'));
        }
      },
    );

    /*
    //  Registrar localmente la informacion resibida por el usuario que activo la alerta.
    //  Muestra mensaje del proceso sobre el registro de la alerta o  en caso de error, un mensaje que lo indica
    */
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

    /*
    //  Emite el estado "AlertReceivedLocation" para visualizar la locacion
    //  del usuario que activo una alerta
    */
    on<ReceivingLocationContactAlert>(
      (event, emit) => emit(AlertReceivedLocation(event.location)),
    );

    /*
    //  Cuando se recibe un evento de tipo AlertDetector, verifica si la alerta está activada 
    //  o desactivada y ejecuta la acción correspondiente en [_alertRepositoryImp]. Luego, emite 
    //  un nuevo estado (AlertActivated o AlertDeactivated) según el resultado.
    */
    on<AlertDetector>(
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

    /*
    //  Cargar y muestra el historial de las alertas resividas y emitidas.
    */
    on<LoadAlertHistory>(
      (event, emit) async {
        emit(AlertLoading());

        try {
          final myHistory = await _alertRepositoryImp.loadMyAlertHistory();
          final contactHistory =
              await _alertRepositoryImp.loadContactsAlertHistory();

          emit(AlertLoadedHistory(myHistory, contactHistory));
        } catch (e) {
          emit(AlertError(message: e.toString(), title: 'Historial'));
        }
      },
    );

    /*
    //  Verificar la existencia del audio almacenado localmente, si es negativa se revisa
    //  en el servidor. Si no existe, me manda un estado con el mensaje con la no existencia
    //  del audio
    */
    on<CheckAudioAlert>((event, emit) async {
      emit(AlertLoading());
      try {
        String? filename = event.filename;

        if (filename == null) {
          emit(AlertAudioNotExists(
              message: 'No se realizo grabación de audio para esta alerta'));
        } else {
          final file = await _alertRepositoryImp.checkAudio(filename);

          if (file != null) {
            emit(AlertAudioDownloaded(file));
          } else {
            emit(AlertAudioExists());
          }
        }
      } catch (e) {
        emit(AlertError(message: e.toString(), title: 'Audio'));
      }
    });

    /*
    //  Descargar audio almacenados en el servidor.
    //  Muestra el audio, un mensaje de no existencia si es que ya no esta dispobible
    //  o mensaje de no existencia
    */
    on<DownloadAudioAlert>(
      (event, emit) async {
        emit(AlertLoading());
        try {
          final filename = event.filename;
          final audio = await _alertRepositoryImp.downloadAudio(filename);

          if (audio != null) {
            emit(AlertAudioDownloaded(audio));
          } else {
            // El audio ha sido borrado del servidor.
            emit(AlertAudioNotExists(
                message: 'El audio ya no está disponible.'));
          }
        } catch (e) {
          emit(AlertError(message: e.toString(), title: 'Descargar'));
        }
      },
    );
  }
}
