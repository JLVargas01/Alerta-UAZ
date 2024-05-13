import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

// Define un tipo para manejar los cambios de estado de la conexión.
typedef ConnectionStatusHandler = void Function(
    bool isConnected, String message);

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late io.Socket _socket;
  final StreamController<Map<String, dynamic>> _streamController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Mensajes constantes para el manejo de errores y estados.
  static const String serverError = "Verificar su conexión a Internet.";
  static const String timeoutError =
      "La conexión con el servidor tardó demasiado.";
  static const String disconnectMessage = "La conexión ha sido perdida.";
  static const String noInternet =
      "No hay conexión a internet. Conéctate a una red para continuar.";

  int _reconnectAttempts = 0;
  final int maxReconnectAttempts = 5;

  Stream<Map<String, dynamic>> get stream => _streamController.stream;
  ConnectionStatusHandler? onStatusChanged;

  // Singleton factory constructor.
  factory SocketService() => _instance;

  // Constructor privado inicializa el socket.
  SocketService._internal() {
    _socket = io.io('http://${dotenv.env['API_URL']}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _initializeSocketListeners();
  }

  // Configura los manejadores de eventos de socket.
  void _initializeSocketListeners() {
    _socket.connect();
    _socket.on('connected', (_) => _updateConnectionStatus(true, ''));
    _socket.on('connect_error', (_) => _handleConnectionIssue(serverError));
    _socket.on('connect_timeout', (_) => _handleConnectionIssue(timeoutError));
    _socket.on('disconnect', (_) => _handleConnectionIssue(disconnectMessage));
  }

  // Maneja problemas de conexión y trata de reconectar.
  void _handleConnectionIssue(String message) {
    _updateConnectionStatus(false, message);
    _attemptReconnect();
  }

  // Intenta reconectar si no se alcanza el máximo de intentos.
  void _attemptReconnect() {
    if (_reconnectAttempts < maxReconnectAttempts) {
      Future.delayed(const Duration(seconds: 5), () {
        if (!_socket.connected) {
          _socket.connect();
          _reconnectAttempts++;
        } else {
          _reconnectAttempts = 0;
        }
      });
    } else {
      _updateConnectionStatus(
          false, "Máximo intento de reconexiones alcanzado.");
    }
  }

  // Actualiza el estado de la conexión y notifica a los suscriptores.
  void _updateConnectionStatus(bool isConnected, String message) {
    onStatusChanged?.call(isConnected, message);
  }

  // Envía datos al servidor si hay conexión.
  void emit(String event, Map<String, dynamic> data) {
    if (_socket.connected) {
      _socket.emit(event, data);
    } else {
      _updateConnectionStatus(false, noInternet);
    }
  }

  // Comienza a escuchar un evento específico si hay conexión.
  void startListening(String event) {
    if (_socket.connected) {
      _socket.on(event, (data) => _streamController.add(data));
    } else {
      _updateConnectionStatus(false, noInternet);
    }
  }

  // Verifica si el socket está conectado.
  bool isConnected() => _socket.connected;

  void dispose() {
    _streamController.close();
    _socket.disconnect();
  }
}
