import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;

void main() {
  String protocol = 'http';
  String hostname = '';
  String port = '3001';

  final String baseUrl = '$protocol://$hostname:$port';

  // ignore: avoid_print
  print('Inicializando socket...');

  // Configuración del cliente del socket
  io.Socket socket = io.io(baseUrl, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    'reconnection': true,
    'reconnectionAttempts': 5,
  });

  // Eventos para monitorear el estado de la conexión
  // ignore: avoid_print
  socket.onConnect((_) => print('Cliente conectado'));
  // ignore: avoid_print
  socket.onConnectError((data) => print("Error de conexión: $data"));
  // ignore: avoid_print
  socket.onDisconnect((_) => print("Socket desconectado"));

  // creando sala
  // ignore: avoid_print
  print('Creando sala');
  socket.emit('createRoom', {'room': 'abcd', 'user': 'Holiwiscach'});

  // Lista de coordenadas
  List<Map<String, dynamic>> coordenadas = [
    {"latitude": 22.75405, "longitude": -102.51264},
    {"latitude": 22.75377, "longitude": -102.51348},
    {"latitude": 22.75459, "longitude": -102.51497},
    {"latitude": 22.75489, "longitude": -102.51712},
    {"latitude": 22.75620, "longitude": -102.51893},
    {"latitude": 22.75723, "longitude": -102.52063},
    {"latitude": 22.75816, "longitude": -102.52254},
    {"latitude": 22.75950, "longitude": -102.52401},
    {"latitude": 22.76041, "longitude": -102.52578},
    {"latitude": 22.76162, "longitude": -102.52795},
    {"latitude": 22.76284, "longitude": -102.52973},
    {"latitude": 22.76429, "longitude": -102.53125},
    {"latitude": 22.76552, "longitude": -102.53299},
    {"latitude": 22.76681, "longitude": -102.53485},
    {"latitude": 22.76794, "longitude": -102.53670},
    {"latitude": 22.76912, "longitude": -102.53846},
    {"latitude": 22.77039, "longitude": -102.54021},
    {"latitude": 22.77156, "longitude": -102.54208},
    {"latitude": 22.77278, "longitude": -102.54401},
    {"latitude": 22.77388, "longitude": -102.54595},
    {"latitude": 22.77500, "longitude": -102.54768},
    {"latitude": 22.77602, "longitude": -102.54942},
    {"latitude": 22.77714, "longitude": -102.55117},
    {"latitude": 22.77820, "longitude": -102.55301},
    {"latitude": 22.77935, "longitude": -102.55477},
    {"latitude": 22.78052, "longitude": -102.55661},
    {"latitude": 22.78165, "longitude": -102.55837},
    {"latitude": 22.78278, "longitude": -102.56012},
    {"latitude": 22.78392, "longitude": -102.56188},
    {"latitude": 22.78500, "longitude": -102.56364},
  ];

  // Conectar y configurar envío de datos
  socket.connect();

  int index = 0;

  Timer.periodic(const Duration(seconds: 5), (timer) {
    if (index < coordenadas.length) {
      socket.emit('sendingCoordinates',
          {'room': 'abcd', 'coordinates': coordenadas[index]});
      // ignore: avoid_print
      print("Coordenada enviada: ${coordenadas[index]}");
      index++;
    } else {
      timer.cancel();
      socket.disconnect();
      // ignore: avoid_print
      print('Socket desconectado');
    }
  });
}
