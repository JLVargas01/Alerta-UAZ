import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/application/location/location_bloc.dart';
import 'package:alerta_uaz/application/location/location_event.dart';
import 'package:alerta_uaz/application/location/location_state.dart';
import 'package:alerta_uaz/application/shake/shake_bloc.dart';
import 'package:alerta_uaz/presentation/widget/load_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  String _message = 'Cargando...';

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(StartSendingLocation());
  }

  Future<bool?> _showStopAlertDialog(BuildContext context) {
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
              // Cada alerta finalizada es registrada.
              context.read<AlertBloc>().add(RegisterAlert()),
              // Se dejan de compartir los datos de ubicación.
              context.read<LocationBloc>().add(StopSendingLocation()),
              // Vuelve activar la herramienta shake.
              context.read<ShakeBloc>().resumeListening(),
              Navigator.pushReplacementNamed(context, '/main')
            },
            child: const Text('Detener'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Alerta activada'),
          const SizedBox(height: 25),
          const Text('Estás compartiendo tu ubicación'),
          const SizedBox(height: 20),
          Text(_message),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () async {
              await _showStopAlertDialog(context);
            },
            child: const Text('Desactivar alerta'),
          ),
        ],
      ),
    );
  }

  /// Método principal que muestra el contenido al usuario.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerta'),
        leading: IconButton(
          onPressed: () async {
            await _showStopAlertDialog(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LocationBloc, LocationState>(
            listener: (context, state) {
              if (state is LocationStarted) {
                context.read<AlertBloc>().add(SendAlert(state.room));
              }
            },
          ),
          BlocListener<AlertBloc, AlertState>(
            listener: (context, state) {
              setState(() {
                _message = state.message!;
              });
            },
          ),
        ],
        child: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            if (state is LocationStarted) {
              return _buildAlertContent(context);
            } else {
              return const LoadWidget(
                message: 'Preparando la alerta...',
              );
            }
          },
        ),
      ),
    );
  }
}
