/*
/// Pantalla para mostrar una alerta activada.
/// Muestra la opcion para desactivar, captura de audio, registra y comparte la ubicacion
*/

import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Alerta'),
          automaticallyImplyLeading: false,
        ),
        body: BlocConsumer<AlertBloc, AlertState>(
          listener: (context, state) {
            if ((state is AlertLoading || state is AlertLoaded) && state.message != null) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message!)));
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
          builder: (context, state) {
            if (state is AlertLoaded) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Haz Activado la alerta'),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () async {
                          final exit = await _stopAlert(context);
                          if (exit == true) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: const Text('Desactivar')),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Future<bool?> _stopAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detener alerta'),
        content: const Text(
            '¿Estás seguro de detener la alerta? Dejarás de compartir tu ubicación y audio.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              context.read<AlertBloc>().add(DesactiveAlert());
              // Se realiza un time sleep de medio segundo.
              // Para que el cambio de estados no sea tan brusco y sea detectable.
              await Future.delayed(const Duration(milliseconds: 500));
              if (context.mounted) {
                context.read<AlertBloc>().add(LoadAlertHistory());
                context.read<AlertBloc>().add(AlertDetector(false));
                Navigator.pop(context, true);
              }
            },
            child: const Text('Detener'),
          ),
        ],
      ),
    );
  }
}
