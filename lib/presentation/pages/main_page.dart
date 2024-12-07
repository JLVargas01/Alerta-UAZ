import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/application/notification/notification_bloc.dart';
import 'package:alerta_uaz/application/notification/notification_state.dart';

import 'package:alerta_uaz/domain/model/notification_model.dart';
import 'package:alerta_uaz/presentation/widget/indexed_stack_navigation.dart';
import 'package:alerta_uaz/presentation/widget/notification_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AlertBloc, AlertState>(
          listener: (context, state) {
            if (state is AlertActivated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed('/alert');
              });
            } else if (state is AlertError) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Error en ${state.title}'),
                  content: Text(state.message!),
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
        ),
        BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationReceived) {
              _showNotificationAlert(context, state.message);
            }
          },
        ),
      ],
      child: const IndexedStackNavigation(),
    );
  }

  void _showNotificationAlert(
      BuildContext context, NotificationMessage message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NotificationAlert(message: message);
      },
    );
  }
}
