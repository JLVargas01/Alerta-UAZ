import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/authentication/auth_bloc.dart';
import 'package:alerta_uaz/application/contact/contact_bloc.dart';
import 'package:alerta_uaz/application/notification/notification_bloc.dart';
import 'package:alerta_uaz/core/device/geolocator_device.dart';
import 'package:alerta_uaz/data/data_sources/remote/firebase_messaging.dart';

import 'package:alerta_uaz/core/constants/routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

/*
//
//  Clase principal main.
//  Carga de variables de entorno, permisos y carga de los providers.
//
*/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseMessagingService.initialize();
  await FirebaseMessagingService.requestPermission();

  await Permission.microphone.request();

  await GeolocatorDevice.initGeolocator();

  await dotenv.load();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => ContactsBloc()),
        BlocProvider(create: (context) => NotificationBloc()),
        BlocProvider(create: (context) => AlertBloc()),
      ],
      child: const AppAlert(),
    ),
  );
}

/*
//
//  StatelessWidget inicial de la aplicacion.
//  Carga de las rutas, la pantalla de carga de la aplicacion
//
*/
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
