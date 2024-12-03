import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/application/location/location_bloc.dart';
import 'package:alerta_uaz/application/location/location_event.dart';
import 'package:alerta_uaz/application/location/location_state.dart';
import 'package:alerta_uaz/presentation/widget/load_widget.dart';
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
    context.read<LocationBloc>().add(StartSendingLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerta'),
      ),
      body: MultiBlocListener(
          listeners: [
            BlocListener<LocationBloc, LocationState>(
              listener: (context, state) {
                if (state is LocationStarted) {
                  // Una vez creado el cuarto, se comparte a los usuairos receptores
                  context.read<AlertBloc>().add(SendAlert(state.room));
                }
              },
            ),
            BlocListener<AlertBloc, AlertState>(
              listener: (context, state) {
                if (state is AlertLoaded || state is AlertLoading) {
                  if (state.message != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message!)),
                    );
                  }
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
            )
          ],
          child: BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              if (state is LocationStarted) {
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
                                Navigator.of(context)
                                    .pushReplacementNamed('/main');
                              });
                            }
                          },
                          child: const Text('Desactivar')),
                    ],
                  ),
                );
              } else {
                return const LoadWidget(
                  message: 'Preparando alerta...',
                );
              }
            },
          )),
    );
  }

  Future<bool?> _stopAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detener alerta'),
        content: const Text(
            '¿Estás seguro de detener la alerta? Dejarás de compartir tu ubicación.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => {
              context.read<LocationBloc>().add(StopSendingLocation()),
              context.read<AlertBloc>().add(RegisterAlert()),
              context.read<AlertBloc>().add(ShakeAlert(false)),
              Navigator.pop(context, true)
            },
            child: const Text('Detener'),
          ),
        ],
      ),
    );
  }
}
