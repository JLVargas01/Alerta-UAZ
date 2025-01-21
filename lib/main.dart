import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/authentication/auth_bloc.dart';
import 'package:alerta_uaz/application/contact/contact_bloc.dart';
import 'package:alerta_uaz/application/notification/notification_bloc.dart';
import 'package:alerta_uaz/application/setting/setting_bloc.dart';
import 'package:alerta_uaz/data/data_sources/remote/firebase_messaging.dart';

import 'package:alerta_uaz/presentation/routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseMessagingService.initialize();
  await FirebaseMessagingService.requestPermission();

  await Permission.microphone.request();

  await Location().requestPermission();
  // Configuración segundo plano
  Location().enableBackgroundMode();
  Location().changeNotificationOptions(
    title: 'Alerta activada',
    subtitle:
        'Toque la notificación para ir a la aplicación y desactivar la alerta.',
    onTapBringToFront: true,
  );

  await dotenv.load();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => ContactsBloc()),
        BlocProvider(create: (context) => NotificationBloc()),
        BlocProvider(create: (context) => AlertBloc()),
        BlocProvider(create: (context) => SettingBloc()),
      ],
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
      debugShowCheckedModeBanner: false,
      routes: routes,
      initialRoute: '/splash',
    );
  }
}
