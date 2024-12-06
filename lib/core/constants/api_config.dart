import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // config
  static final String protocol = dotenv.env['PROTOCOL'] ?? 'http';
  static final String hostname = dotenv.env['HOST_NAME'] ?? 'localhost';
  static final String pref = dotenv.env['PREF'] ?? '/api';
  // ports
  static final String portUser = dotenv.env['PORT_USER'] ?? '3000';
  static final String portAlert = dotenv.env['PORT_ALERT'] ?? '3002';
  static final String portSocket = dotenv.env['PORT_SOCKET'] ?? '3001';
  static final String portNotification =
      dotenv.env['PORT_NOTIFICATION'] ?? '3003';

  // endpoints
  // Usuario
  static final String createContact =
      dotenv.env['USER_CREATE_CONTACT'] ?? '/api/contact/createContact';
  static final String deleteContact = dotenv.env['USER_DELETE_CONTACT'] ?? '';

  static const headerKey = "********************************************";

  /// Genera la URL base para un servicio específico.
  ///
  /// [port] es el puerto del servicio.
  /// [service] es el nombre opcional del servicio API.
  /// Si [service] es `null` o está vacío, se devuelve solo la URL base sin la ruta del servicio.
  static String getBaseUrl(String port, [String? service]) {
    final base = '$protocol://$hostname:$port';
    return service != null && service.trim().isNotEmpty
        ? '$base$pref/$service'
        : base;
  }
}
