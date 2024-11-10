import 'dart:async';

import 'package:alerta_uaz/data/data_sources/remote/socket_service.dart';
import 'package:alerta_uaz/domain/repositories/location_repository.dart';
import 'package:location/location.dart';

class LocationRepositoryImp implements LocationRepository {
  final _socket = SocketService();

  Timer? _timer;

  @override
  void startReceivedLocation(
      String room, String username, Function(dynamic) handler) {
    _socket.connect();

    _socket.emit('joinRoom', {'room': room, 'user': username});

    _socket.on('newCoordinates', handler);
  }

  @override
  void startSendLocation(String room, String username) {
    _socket.connect();

    _socket.emit('createRoom', {'room': room, 'user': username});

    LocationData locationData;
    Map<String, dynamic> coordinates;

    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      locationData = await Location().getLocation();

      coordinates = {
        'latitude': locationData.latitude,
        'longitude': locationData.longitude
      };

      _socket.emit(
          'sendingCoordinates', {'room': room, 'coordinates': coordinates});
    });
  }

  @override
  void stopReceivedLocation() {
    _socket.disconnect();
  }

  @override
  void stopSendLocation() {
    _timer!.cancel();
    _socket.disconnect();
  }
}
