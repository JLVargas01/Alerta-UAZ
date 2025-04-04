import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
//  Configuración de la API para la aplicación.
//  Esta clase 'ApiConfig' proporciona las configuraciones necesarias para construir 
//  las URL base de los diferentes servicios de la API. Extrae variables del entorno 
//  utilizando 'flutter_dotenv' para definir el protocolo, el hostname y los puertos 
//  de los distintos servicios (usuarios, alertas, notificaciones y sockets). 
*/

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

  static const headerKey = "********************************************";

  /// Genera la URL base para un servicio específico.
  /// [port] es el puerto del servicio.
  /// [service] es el nombre opcional del servicio API.
  /// Si [service] es 'null' o está vacío, se devuelve solo la URL base sin la ruta del servicio.
  static String getBaseUrl(String port, [String? service]) {
    final base = '$protocol://$hostname:$port';
    return service != null && service.trim().isNotEmpty
        ? '$base$pref/$service'
        : base;
  }
}
