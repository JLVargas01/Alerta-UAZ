import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // config
  static final String protocol = dotenv.env['PROTOCOL'] ?? 'http';
  static final String hostname = dotenv.env['HOST_NAME'] ?? 'localhost';
  // ports
  static final String portUser = dotenv.env['PORT_USER'] ?? '3000';
  static final String portNotification =
      dotenv.env['PORT_NOTIFICATION'] ?? '3000';

  // endpoints
  static final String notificationAlert =
      dotenv.env['NOTIFICATION_ALERT'] ?? '';

  static const headerKey = "********************************************";

  static String getBaseUrl(String port) {
    return '$protocol://$hostname:$port';
  }
}