/*
/// Splash de carga de la applicacion
*/

import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/authentication/auth_bloc.dart';
import 'package:alerta_uaz/application/authentication/auth_event.dart';
import 'package:alerta_uaz/application/authentication/auth_state.dart';
import 'package:alerta_uaz/application/notification/notification_bloc.dart';
import 'package:alerta_uaz/application/notification/notification_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckUserAuthentication());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.read<NotificationBloc>().add(EnabledNotification());
          context.read<AlertBloc>().add(EnabledAlert());

          Navigator.of(context).pushReplacementNamed("/home");
        } else if (state is Unauthenticated) {
          Navigator.of(context).pushReplacementNamed("/login");
        } else if (state is AuthError) {
          context.read<AuthBloc>().add(CheckUserAuthentication());
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Alerta UAZ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
