import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Alerta activada'),
          automaticallyImplyLeading: false,
        ),
        body: BlocListener<AlertBloc, AlertState>(
          listener: (context, state) {
            if (state is AlertSent) {
              // mensaje de notificación enviada a contactos
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.success)));
            } else if (state is AlertError) {
              // mensaje de error al enviar notificación
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Activaste una alerta'),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      context.read<AlertBloc>().resumeListeningShake();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushReplacementNamed('/main');
                      });
                    },
                    child: const Text('Desactivar alerta'))
              ],
            ),
          ),
        ));
  }
}