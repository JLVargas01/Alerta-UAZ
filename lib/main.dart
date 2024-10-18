import 'package:alerta_uaz/application/authentication/auth_bloc.dart';
import 'package:alerta_uaz/presentation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  runApp(
    BlocProvider(
      create: (context) => AuthBloc()
        ..add(CheckUserAuthentication()), // Verifica si ya está autenticado
      child: const AppAlert(),
    ),
  );
}

class AppAlert extends StatelessWidget {
  const AppAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      routes: routes,
      home: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/main');
              });
            } else if (state is Unauthenticated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/login');
              });
            }
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}


// import 'package:alerta_uaz/pages/alert_screen.dart';
// import 'package:alerta_uaz/pages/contacts_screen.dart';
// import 'package:alerta_uaz/pages/location_screen.dart';
// import 'package:alerta_uaz/pages/logged_in_screen.dart';
// import 'package:alerta_uaz/pages/login_screen.dart';

// import 'package:alerta_uaz/services/api_service.dart';
// import 'package:alerta_uaz/services/push_notification_service.dart';
// import 'package:alerta_uaz/services/shake_detector_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// final Map<String, WidgetBuilder> routes = {
//   "/singIn": (_) => const SignInUsuario(),
//   "/location": (_) => const LocationPage(),
//   "/alert": (_) => const AlertPage(),
//   "/contacts": (_) => const ContactosPage(),
//   "/main": (_) => const LoggedInPage(),
// };

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await dotenv.load(fileName: '.env');

//   PushNotificationService.initialize();

//   ShakeDetectorService.startListening(() async {
//     await apiService.sendNotification('4921231234');
//     ShakeDetectorService.pauseListening();

//     navigatorKey.currentState
//         ?.pushReplacement(MaterialPageRoute(builder: (_) => const AlertPage()));
//   });

//   runApp(const AppAlerta());
// }

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// ApiService apiService = ApiService();

// class AppAlerta extends StatelessWidget {
//   const AppAlerta({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       initialRoute: "/singIn",
//       routes: routes,
//     );
//   }
// }
