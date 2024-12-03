import 'dart:async';

import 'package:alerta_uaz/data/data_sources/remote/socket_service.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:location/location.dart';

class LocationRepositoryImp {
  final _socket = SocketService();
  final _user = User();

  Timer? _timer;

  void startReceivedLocation(String room, Function(dynamic) handler) {
    _socket.connect();

    // Nos unimos al canal para visualizar la ubicación del emisor
    _socket.emit('joinRoom', {'room': room, 'user': _user.name});
    // Obtenemos y mostramos las coordenadas
    _socket.on('newCoordinates', handler);
  }

  String startSendLocation() {
    _socket.connect();

    // Se crea un cuarto dónde solo usuarios específicos podrán entrar
    final room = '${DateTime.now()}:${_user.name}'.replaceAll(' ', '');
    // El usuario emisor abre un nuevo cuarto donde compartira su ubicación
    _socket.emit('createRoom', {'room': room, 'user': _user.name});

    // Envío constante de ubicación
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

    return room;
  }

  void stopReceivedLocation() {
    _socket.disconnect();
  }

  void stopSendLocation() {
    _timer!.cancel();
    _socket.disconnect();
  }
}
