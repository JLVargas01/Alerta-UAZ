import 'package:alerta_uaz/application/location/location_event.dart';
import 'package:alerta_uaz/application/location/location_state.dart';
import 'package:alerta_uaz/data/repositories/location_repository_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final _locationRepositoryImp = LocationRepositoryImp();

  LocationBloc() : super(LocationInitial()) {
    on<StartSendingLocation>(
      (event, emit) async {
        emit(LocationLoading());
        final room = _locationRepositoryImp.startSendLocation();
        await Future.delayed(const Duration(milliseconds: 500));
        emit(LocationStarted(room));
      },
    );

    on<StopSendingLocation>(
      (event, emit) {
        _locationRepositoryImp.stopSendLocation();
        emit(LocationInitial());
      },
    );

    on<StopReceivingLocation>(
      (event, emit) {
        _locationRepositoryImp.stopReceivedLocation();
        emit(LocationInitial());
      },
    );

    on<StartReceivingLocation>(
      (event, emit) {
        emit(LocationLoading());

        handler(dynamic location) {
          add(ReceivingLocation(
              LatLng(location['latitude'], location['longitude'])));
        }

        _locationRepositoryImp.startReceivedLocation(event.room, handler);
      },
    );

    on<ReceivingLocation>(
      (event, emit) => emit(LocationReceived(event.location)),
    );
  }
}
