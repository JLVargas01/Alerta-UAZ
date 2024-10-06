import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  io.Socket? _socket;

  SocketService._internal() {
    _initialize();
  }

  factory SocketService() {
    return _instance;
  }

  void _initialize() {
    final String? protocol = dotenv.env['PROTOCOL'];
    final String? hostname = dotenv.env['HOST_NAME'];
    final String? port = dotenv.env['PORT_SOCKET'];

    if (protocol == null || hostname == null || port == null) {
      throw Exception(
          'Error: Asegúrate de que PROTOCOL, HOST_NAME y PORT están definidos.');
    }

    final String url = '$protocol://$hostname:$port';

    _socket = io.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionAttempts': 5,
    });

    _socket?.onConnect((_) {
      print('Conectado a $url');
    });

    _socket?.onDisconnect((_) {
      print('Desconectado del servidor');
    });

    _socket?.onError((data) {
      print('Error: $data');
    });
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  void disconnect() {
    _socket?.disconnect();
  }
}
