/*
/// Servicio para gestionar la conexión WebSocket con el servidor.
/// 
/// Esta clase implementa un singleton para manejar un único socket en toda la aplicación.
/// Permite conectarse, desconectarse, escuchar eventos y emitir datos al servidor.
*/

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {

  /// Instancia única de [SocketService].
  static final SocketService _instance = SocketService._internal();

  /// Instancia del socket cliente.
  late io.Socket _socket;

  /// URL base para la conexión con el servidor WebSocket.
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portSocket);

  /// Constructor privado para la implementación del singleton.
  SocketService._internal() {
    _socket = io.io(_baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionAttempts': 5,
    });
  }

  /// Devuelve la instancia única de [SocketService].
  factory SocketService() {
    return _instance;
  }

  /// Inicializa los eventos de conexión y desconexión.
  /// [handler] : Función que maneja los eventos de conexión, desconexión y errores.
  void initialize(Function(dynamic) handler) {
    _socket.onConnect((_) => handler('Conectado'));
    _socket.onDisconnect((_) => handler('Desconectado'));
    _socket.onError((_) => handler('Error en el servidor'));
  }

  /// Envía un evento al servidor con los datos proporcionados.
  /// 
  /// [event] : Nombre del evento a emitir.
  /// [data] : Datos a enviar al servidor en formato de mapa clave-valor.
  void emit(String event, Map<String, dynamic> data) {
    _socket.emit(event, data);
  }

  /// Escucha eventos provenientes del servidor.
  /// 
  /// [event] : Nombre del evento a escuchar.
  /// [handler] : Función que maneja los datos recibidos del servidor.
  void on(String event, Function(dynamic) handler) {
    _socket.on(event, handler);
  }

  /// Conecta el socket al servidor.
  void connect() {
    _socket.connect();
  }

  /// Desconecta el socket del servidor.
  void disconnect() {
    _socket.disconnect();
  }
}
