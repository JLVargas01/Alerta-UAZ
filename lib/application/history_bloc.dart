import 'package:alerta_uaz/data/data_sources/local/alerts_received_db.dart';
import 'package:alerta_uaz/data/data_sources/local/alerts_sent_db.dart';
import 'package:alerta_uaz/domain/model/alerts_received_model.dart';
import 'package:alerta_uaz/domain/model/alerts_sent_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HistoryEvent {}

class FetchHistoryEvent extends HistoryEvent {}

abstract class HistoryState {}

class HistoryInitialState extends HistoryState {}

class HistoryLoadingState extends HistoryState {}

class HistoryLoadedState extends HistoryState {
  final List<AlertReceived> receivedAlerts;
  final List<AlertSent> sentAlerts;
  HistoryLoadedState(this.receivedAlerts, this.sentAlerts);
}

class HistoryErrorState extends HistoryState {
  final String error;

  HistoryErrorState(this.error);
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {

  HistoryBloc() : super(HistoryInitialState()) {
    on<FetchHistoryEvent>((event, emit) async {
      emit(HistoryLoadingState());
      try {
        // Obtener alertas emitidas por otros usuasios
        final AlertsReceived alertasRecibidasDB = AlertsReceived();
        final listaRecividasAlmacenadas = await alertasRecibidasDB.getAlertsReceived();

        final AlertsSent alertasEmitidasDB = AlertsSent();
        final listaEmitidasAlmacenadas = await alertasEmitidasDB.getAlertsSent();

        emit(HistoryLoadedState(listaRecividasAlmacenadas,listaEmitidasAlmacenadas));
      } catch (e) {
        emit(HistoryErrorState('Error al cargar el historial'));
      }
    });

  }
}
