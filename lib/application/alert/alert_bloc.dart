import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/notification_service.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final NotificationService _notificationService = NotificationService();

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
        try {
          if (user != null) {
            String room = event.room;

            String? contacts = user!.idContacts;

            Map<String, dynamic> data = {
              'id_room': room,
              'name': user!.name,
              'avatar': user!.avatar
            };

            final message =
                await _notificationService.sendAlert(contacts, data);

            emit(AlertSent(message));
          } else {
            emit(AlertError(
                'Envío de alerta no disponible. No está registrado.'));
          }
        } catch (e) {
          emit(AlertError(e.toString()));
        }
      },
    );
  }
}
