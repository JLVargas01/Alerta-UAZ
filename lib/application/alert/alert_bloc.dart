import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/alert_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/notification_api.dart';
import 'package:alerta_uaz/data/repositories/alert_repository_impl.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final _alertRepositoryImp =
      AlertRepositoryImpl(NotificationApi(), AlertApi());

  User? user;

  AlertBloc() : super(AlertInitial()) {
    on<EnabledAlert>(
      (event, emit) {
        user = event.user;
      },
    );

    on<DisabledAlert>(
      (event, emit) {
        user = null;
      },
    );

    on<SendAlert>(
      (event, emit) async {
        emit(AlertLoading(message: 'Enviando notificación a contactos....'));
        String room = event.room;
        try {
          await _alertRepositoryImp.sendAlert(room, user!);
          emit(AlertSent(message: 'La alerta fue envíada exitosamente.'));
        } catch (e) {
          emit(AlertError(message: e.toString()));
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
          emit(AlertError(message: e.toString()));
        }
      },
    );
  }
}
