import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late io.Socket _socket;

  final StreamController<Map<String, dynamic>> _streamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => _streamController.stream;

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

  // Envia datos a un canal en especifico
  void emit(String event, Map<String, dynamic> data) {
    if (_socket.connected) {
      _socket.emit(event, data);
    } else {
      print('Socket is not connected');
    }
  }

  // Empieza a recibir datos del canal especificado
  void startListening(event) {
    if (_socket.connected) {
      _socket.on(event, (data) => _streamController.add(data));
    } else {
      print('Socket is not connected');
    }
  }

  void dispose() {
    _socket.disconnect();
  }
}
