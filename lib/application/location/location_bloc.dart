import 'dart:async';

import 'package:alerta_uaz/application/location/location_event.dart';
import 'package:alerta_uaz/application/location/location_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/socket_service.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final SocketService _socket = SocketService();
  final Location _location = Location();

  User? user;
  Timer? _timer;

  LocationBloc() : super(LocationInitial()) {
    on<EnabledLocation>(
      (event, emit) {
        user = event.user;
      },
    );
    on<DisabledLocation>(
      (event, emit) {
        _socket.disconnect();
      },
    );
    on<StartSendingLocation>(_startSending);
    on<StopSendingLocation>(_stopSending);
  }

  void _startSending(StartSendingLocation event, Emitter<LocationState> emit) {
    emit(LocationLoading());

    _socket.connected();

    final room = '${DateTime.now()}:${user!.name}'.replaceAll(' ', '');

    _socket.emit('createRoom', {'room': room, 'user': user!.name});

    emit(LocationConnected(room));

    LocationData locationData;
    Map<String, dynamic> coordinates;

    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      locationData = await _location.getLocation();

      coordinates = {
        'latitude': locationData.latitude,
        'longitude': locationData.longitude
      };

      _socket.emit(
          'sendingCoordinates', {'room': room, 'coordinates': coordinates});
    });
  }

  void _stopSending(LocationEvent event, Emitter<LocationState> emit) {
    _timer?.cancel();
    _socket.disconnect();
  }
}
