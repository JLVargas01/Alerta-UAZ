import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/authentication/auth_bloc.dart';
import 'package:alerta_uaz/application/contact-list_bloc.dart';
import 'package:alerta_uaz/application/history_bloc.dart';
import 'package:alerta_uaz/application/location/location_bloc.dart';
import 'package:alerta_uaz/application/notification/notification_bloc.dart';
import 'package:alerta_uaz/application/setting/setting_bloc.dart';

import 'package:alerta_uaz/data/data_sources/remote/firebase_service.dart';
import 'package:alerta_uaz/presentation/routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService().initializeApp();

  await dotenv.load();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => ContactsBloc()..add(LoadContacts())),
        BlocProvider(
            create: (context) => HistoryBloc()..add(FetchHistoryEvent())),
        BlocProvider(create: (context) => NotificationBloc()),
        BlocProvider(create: (context) => AlertBloc()),
        BlocProvider(create: (context) => LocationBloc()),
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
