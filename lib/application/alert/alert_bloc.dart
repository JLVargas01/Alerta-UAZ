import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/data/repositories/notification_repository_imp.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final _notificationRepositoryImp = NotificationRepositoryImp();

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
        emit(AlertSending());

        String room = event.room;
        String? contacts = user!.idContacts;

        // Estructura para compartir la ubicación actual del emisor
        Map<String, dynamic> data = {
          'room': room, // Cuarto dónde se compartira la localización.
          'name': user!.name, // Nombre del emisor que envía la alerta
          'avatar': user!.avatar
        };

        try {
          await _notificationRepositoryImp.sendAlert(contacts!, data);
          emit(AlertSent('La alerta fue envíada exitosamente.'));
        } catch (e) {
          emit(AlertError(e.toString()));
        }
      },
    );
  }
}
