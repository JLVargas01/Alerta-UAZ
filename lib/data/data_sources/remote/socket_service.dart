import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  late io.Socket _socket;

  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portSocket);

  SocketService._internal() {
    _socket = io.io(_baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionAttempts': 5,
    });
  }

  factory SocketService() {
    return _instance;
  }

  void initialize(Function(dynamic) handler) {
    _socket.onConnect((_) => handler('Conectado'));

    _socket.onDisconnect((_) => handler('Desconectado'));

    _socket.onError((_) => handler('Error en el servidor'));
  }

  void emit(String event, Map<String, dynamic> data) {
    _socket.emit(event, data);
  }

  void on(String event, Function(dynamic) handler) {
    _socket.on(event, handler);
  }

  void connect() {
    _socket.connect();
  }

  void disconnect() {
    _socket.disconnect();
  }
}
