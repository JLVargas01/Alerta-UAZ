import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HistoryEvent {}

class FetchHistoryEvent extends HistoryEvent {}

abstract class HistoryState {}

class HistoryInitialState extends HistoryState {}

class HistoryLoadingState extends HistoryState {}

class HistoryLoadedState extends HistoryState {
  final List<String> receivedAlerts; // Lista de alertas recibidas
  final List<String> sentAlerts;     // Lista de alertas enviadas

  HistoryLoadedState({
    required this.receivedAlerts,
    required this.sentAlerts,
  });
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
        // Simulación de carga de datos
        await Future.delayed(const Duration(seconds: 2));

        // Ejemplo de datos de prueba
        final receivedAlerts = [
          "Alerta recibida 1",
          "Alerta recibida 2",
          "Alerta recibida 3",
        ];
        final sentAlerts = [
          "Alerta enviada 1",
          "Alerta enviada 2",
        ];

        emit(HistoryLoadedState(
          receivedAlerts: receivedAlerts,
          sentAlerts: sentAlerts,
        ));
      } catch (e) {
        emit(HistoryErrorState('Error al cargar el historial'));
      }
    });
  }
}
