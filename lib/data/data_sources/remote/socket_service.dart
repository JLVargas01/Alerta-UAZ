import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  io.Socket? _socket;

  SocketService._internal() {
    _socket ??= io.io(_baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionAttempts': 5,
    });
  }

  factory SocketService() {
    return _instance;
  }

  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portSocket);

  void initialize() {
    _socket?.onConnect((_) {
      print('Conectado a $_baseUrl');
    });

    _socket?.onDisconnect((_) {
      print('Desconectado del servidor');
    });

    _socket?.onError((data) {
      print('Error: $data');
    });
  }

  void emit(String event, Map<String, dynamic> data) {
    _socket?.emit(event, data);
  }

  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  void connected() {
    if (_socket!.connected == false) {
      _socket?.connect();
    }
  }

  void disconnect() {
    _socket?.disconnect();
  }
}
