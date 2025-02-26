import 'package:alerta_uaz/application/notification/notification_event.dart';
import 'package:alerta_uaz/application/notification/notification_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/firebase_messaging.dart';
import 'package:alerta_uaz/data/data_sources/remote/user_api.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
//
//  Clase para manejar las notificaciones
//  _alertRepositoryImp: Variable final para realizar los distintos
//  metodos de comunicacion hacia la API.
//
*/ 
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {

  final UserApi _userApi = UserApi();

  NotificationBloc() : super(NotificationInitial()) {

    /*
    //  Habilitar las notificaciones para el usuario
    */
    on<EnabledNotification>(
      (event, emit) {
        // Configuramos las eventos para notificaciones
        FirebaseMessagingService.setUp();
        // Obtenemos las notificaciones push conforme se obtengan en el stream.
        final stream = FirebaseMessagingService.stream;
        // Añadimos eventos para cada tipo de notificaiones
        stream.listen((message) => add(ReceiveNotification(message)));
        // Actualizamos el token automaticamente cada vez que caduca.
        FirebaseMessagingService.refreshToken((newToken) {
          _userApi.updateToken(User().id!, newToken);
        });
      },
    );

    /*
    //  Desabilita las notificaciones para el usuario
    */
    on<DisabledNotification>(
      (event, emit) => FirebaseMessagingService.deleteToken(),
    );

    /*
    //  Funcion para mostrar una notificacion
    //  $ComentarioPorRevisar
    */
    on<ReceiveNotification>((event, emit) async {
      emit(NotificationReceived(event.message));
      await Future.delayed(const Duration(milliseconds: 500));
      emit(NotificationInitial());
    });
  }
}
