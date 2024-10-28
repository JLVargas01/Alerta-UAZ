import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

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
    final String baseUrl = ApiConfig.getBaseUrl(ApiConfig.portSocket);

    _socket = io.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionAttempts': 5,
    });

    _socket?.onConnect((_) {
      print('Conectado a $baseUrl');
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
