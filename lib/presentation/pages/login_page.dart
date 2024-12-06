import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/authentication/auth_bloc.dart';
import 'package:alerta_uaz/application/authentication/auth_event.dart';
import 'package:alerta_uaz/application/authentication/auth_state.dart';
import 'package:alerta_uaz/application/notification/notification_bloc.dart';
import 'package:alerta_uaz/application/notification/notification_event.dart';
import 'package:alerta_uaz/presentation/widget/load_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Bienvenido a AlertUAZ')),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              // Habilita las funciones necesarias
              context.read<NotificationBloc>().add(EnabledNotification());
              context.read<AlertBloc>().add(EnabledAlert());

              Navigator.of(context).pushReplacementNamed("/home");
            } else if (state is AuthNeedsPhoneNumber) {
              // Redirige a la solicitud de número de teléfono
              Navigator.of(context).pushNamed('/requestPhone');
            } else if (state is AuthError) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error al autenticar'),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () => {Navigator.pop(context)},
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              );
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Unauthenticated) {
                return Center(
                    child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignIn());
                  },
                  child: const Text('Entrar con Google'),
                ));
              } else {
                return const LoadWidget(
                  message: 'Cargando...',
                );
              }
            },
          ),
        ));
  }
}
