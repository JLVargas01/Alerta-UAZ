import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/application/location/location_bloc.dart';
import 'package:alerta_uaz/application/location/location_event.dart';
import 'package:alerta_uaz/application/location/location_state.dart';
import 'package:alerta_uaz/application/shake/shake_bloc.dart';
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
        title: const Text('Alerta activada'),
        automaticallyImplyLeading: false,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LocationBloc, LocationState>(listener: (context, state) {
            if (state is LocationStarted) {
              // Envía notificación de alerta a contactos
              context.read<AlertBloc>().add(SendAlert(state.room));
            }
          }),
          BlocListener<AlertBloc, AlertState>(listener: (context, state) {
            if (state is AlertSending) {
              _scaffold(context, 'Enviando notificación a contactos');
            } else if (state is AlertSent) {
              _scaffold(context, state.message);
            } else if (state is AlertError) {
              _scaffold(context, state.error);
            }
          })
        ],
        child: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            if (state is LocationLoading) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context.read<LocationBloc>().add(StopSendingLocation());
                        context.read<ShakeBloc>().resumeListening();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pushReplacementNamed('/main');
                        });
                      },
                      child: const Text('Cancelar y regresar'))
                ],
              ));
            } else if (state is LocationStarted) {
              return _buildMain(context);
            } else {
              return const Center(
                child: Text('Alerta no disponible'),
              );
            }
          },
        ),
      ),
    );
  }

  void _scaffold(BuildContext context, message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildMain(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Activaste una alerta.'),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                context.read<LocationBloc>().add(StopSendingLocation());
                context.read<ShakeBloc>().resumeListening();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed('/main');
                });
              },
              child: const Text('Desactivar alerta'))
        ],
      ),
    );
  }
}
