/*
/// Pantalla principal de la app
/// Se muestra el perfil, la lista de contactos y el historial de alertas
/// Tambien se muestran las alertas cuando ocurren
*/

import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/application/notification/notification_bloc.dart';
import 'package:alerta_uaz/application/notification/notification_state.dart';

import 'package:alerta_uaz/presentation/widget/indexed_stack_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AlertBloc, AlertState>(
          listener: (context, state) {
            if (state is AlertActivated) {
              context.read<AlertBloc>().add(ActiveAlert());
              Navigator.of(context).pushNamed('/alert');
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
          listener: (context, state) async {
            if (state is NotificationReceived) {
              String? type = state.message.data['type']?.toString().trim();
              bool? action = await showDialog<bool?>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(state.message.notification!.title!),
                  content: Text(state.message.notification!.body!),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );

              // Solo entrara en caso de ser un ALERT_ACTIVATED
              if (action == true && type != null && type == "ALERT_ACTIVATED") {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context)
                      .pushNamed('/map', arguments: state.message.data['room']);
                });
              } else if (type != null && type == 'ALERT_DESACTIVATED') {
                final data = state.message.data;
                // ignore: use_build_context_synchronously
                context.read<AlertBloc>().add(RegisterContactAlert(data));
                // ignore: use_build_context_synchronously
                context.read<AlertBloc>().add(LoadAlertHistory());
              }
            }
          },
        ),
      ],
      child: const IndexedStackNavigation(),
    );
  }
}
