import 'package:alerta_uaz/pages/alert_screen.dart';
import 'package:alerta_uaz/pages/contacts_screen.dart';
import 'package:alerta_uaz/pages/location_screen.dart';
import 'package:alerta_uaz/pages/logged_in_screen.dart';
import 'package:alerta_uaz/pages/login_screen.dart';

import 'package:alerta_uaz/services/api_service.dart';
import 'package:alerta_uaz/services/push_notification_service.dart';
import 'package:alerta_uaz/services/shake_detector_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final Map<String, WidgetBuilder> routes = {
  "/singIn": (_) => const SignInUsuario(),
  "/location": (_) => const LocationPage(),
  "/alert": (_) => const AlertPage(),
  "/contacts": (_) => const ContactosPage(),
  "/main": (_) => const LoggedInPage(),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  PushNotificationService.initialize();

  ShakeDetectorService.startListening(() async {
    await apiService.sendNotification('4921231234');
    ShakeDetectorService.pauseListening();

    navigatorKey.currentState
        ?.pushReplacement(MaterialPageRoute(builder: (_) => const AlertPage()));
  });

  runApp(const AppAlerta());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
ApiService apiService = ApiService();

class AppAlerta extends StatelessWidget {
  const AppAlerta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      initialRoute: "/singIn",
      routes: routes,
    );
  }
}
