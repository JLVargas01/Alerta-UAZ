import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // config
  static final String protocol = dotenv.env['PROTOCOL'] ?? 'http';
  static final String hostname = dotenv.env['HOST_NAME'] ?? 'localhost';
  // ports
  static final String portUser = dotenv.env['PORT_USER'] ?? '3000';
  static final String portSocket = dotenv.env['PORT_SOCKET'] ?? '3000';
  static final String portNotification =
      dotenv.env['PORT_NOTIFICATION'] ?? '3000';

  // endpoints
  // Usuario
  static final String singIn = dotenv.env['USER_SIGN_IN'] ?? '';
  static final String getInfoUserByEmail = dotenv.env['USER_GET_USER_EMAIL'] ?? '';
  static final String createContact = dotenv.env['USER_CREATE_CONTACT'] ?? '';
  static final String deleteContact = dotenv.env['USER_DELETE_CONTACT'] ?? '';
  // Notificación
  static final String notificationAlert =dotenv.env['NOTIFICATION_ALERT'] ?? '';

  static const headerKey = "********************************************";

  static String getBaseUrl(String port) {
    return '$protocol://$hostname:$port';
  }
}
