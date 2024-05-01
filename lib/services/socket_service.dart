import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late io.Socket _socket;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal() {
    _socket = io.io('http://${dotenv.env['API_URL']}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
  }

  void initialize() {
    _socket.connect();
  }

  void emit(String event, String data) {
    if (_socket.connected) {
      _socket.emit(event, data);
    } else {
      print('Socket is not connected');
    }
  }

  void dispose() {
    _socket.disconnect();
  }
}
