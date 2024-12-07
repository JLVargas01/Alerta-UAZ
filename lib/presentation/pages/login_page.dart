import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/authentication/auth_bloc.dart';
import 'package:alerta_uaz/application/authentication/auth_event.dart';
import 'package:alerta_uaz/application/authentication/auth_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bienvenido a AlertUAZ'),
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              // context.read<NotificationBloc>().add(EnabledNotification());
              context.read<AlertBloc>().add(EnabledAlert());

              Navigator.of(context).pushReplacementNamed("/main");
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
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(SignIn());
                      },
                      child: const Text('Registrarse con Google'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogIn());
                      },
                      child: const Text('Iniciar sesión con Google'),
                    ),
                  ],
                ));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}
