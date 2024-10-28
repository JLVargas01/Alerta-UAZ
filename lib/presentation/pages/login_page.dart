import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';

import 'package:alerta_uaz/application/authentication/auth_bloc.dart';
import 'package:alerta_uaz/application/authentication/auth_event.dart';
import 'package:alerta_uaz/application/authentication/auth_state.dart';

import 'package:alerta_uaz/application/notification/notification_bloc.dart';
import 'package:alerta_uaz/application/notification/notification_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Verifica si ya está autenticado
    context.read<AuthBloc>().add(CheckUserAuthentication());
    return Scaffold(
        appBar: AppBar(
          title: const Text('Iniciar Sesión con Google'),
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              // Activa las funciones para usuarios autenticados
              context.read<NotificationBloc>().add(EnabledNotification());
              context.read<AlertBloc>().add(EnabledAlert(state.user));
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed('/main');
              });
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(SignIn());
                    },
                    child: const Text('Iniciar sesión con Google'),
                  ),
                );
              }
            },
          ),
        ));
  }
}
