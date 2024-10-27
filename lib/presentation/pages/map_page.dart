import 'package:alerta_uaz/application/alert_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  //Latitud: 22.7733
  //Longitud: -102.5905

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    // Utiliza 'message' según tus necesidades
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mapa'),
          automaticallyImplyLeading: false,
        ),
        body: BlocListener<AlertBloc, AlertState>(
          listener: (context, state) {
            if (state is AlertSent) {
              // mensaje de notificación enviada a contactos
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.success)));
            } else if (state is AlertSending) {
              // mensaje de notificaicón enviandose
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enviando alerta...')));
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
                Text('Datos de la notificación: ${data['name']}'),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      context.read<AlertBloc>().resumeListeningShake();
                      Navigator.pop(context);
                    },
                    child: const Text('Regresar'))
              ],
            ),
          ),
        ));
  }
}
