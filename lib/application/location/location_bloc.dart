import 'package:alerta_uaz/application/location/location_event.dart';
import 'package:alerta_uaz/application/location/location_state.dart';
import 'package:alerta_uaz/data/repositories/location_repository_imp.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final _locationRepositoryImp = LocationRepositoryImp();

  User? user;

  LocationBloc() : super(LocationInitial()) {
    on<EnabledLocation>(
      (event, emit) {
        user = event.user;
      },
    );
    on<DisabledLocation>(
      (event, emit) {
        user = null;
      },
    );

    on<StartSendingLocation>(
      (event, emit) async {
        emit(LocationLoading());

        final room = '${DateTime.now()}:${user!.name}'.replaceAll(' ', '');
        _locationRepositoryImp.startSendLocation(room, user!.name!);
        await Future.delayed(const Duration(milliseconds: 500));
        emit(LocationStarted(room));
      },
    );

    on<StopSendingLocation>(
      (event, emit) {
        _locationRepositoryImp.stopSendLocation();
      },
    );

    on<StopReceivingLocation>(
      (event, emit) {
        _locationRepositoryImp.stopReceivedLocation();
      },
    );

    on<StartReceivingLocation>(
      (event, emit) {
        emit(LocationLoading());

        handler(dynamic location) {
          add(ReceivedLocation(
              LatLng(location['latitude'], location['longitude'])));
        }

        final room = event.room;
        _locationRepositoryImp.startReceivedLocation(
            room, user!.name!, handler);
      },
    );

    on<ReceivedLocation>(
      (event, emit) {
        emit(LocationReceived(event.location));
      },
    );
  }
}
