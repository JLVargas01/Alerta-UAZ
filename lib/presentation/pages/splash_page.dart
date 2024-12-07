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
          // context.read<NotificationBloc>().add(EnabledNotification());
          context.read<AlertBloc>().add(EnabledAlert());

          Navigator.of(context).pushReplacementNamed("/main");
        } else if (state is Unauthenticated) {
          Navigator.of(context).pushReplacementNamed("/login");
        } else if (state is AuthError) {
          context.read<AuthBloc>().add(CheckUserAuthentication());
        }
      },
      child: Container(
        color: Colors.blue[900],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/EscudoUAZ.png',
                fit: BoxFit.contain,
                width: 150.0,
                height: 150.0,
              ),
              const SizedBox(
                height: 30,
              ),
              CircularProgressIndicator(
                color: Colors.amberAccent[400],
              )
            ],
          ),
        ),
      ),
    );
  }
}
