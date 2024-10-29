import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/application/location/location_bloc.dart';
import 'package:alerta_uaz/application/location/location_event.dart';
import 'package:alerta_uaz/application/location/location_state.dart';
import 'package:alerta_uaz/application/shake/shake_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<LocationBloc>().add(StartSendingLocation());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerta activada'),
        automaticallyImplyLeading: false,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LocationBloc, LocationState>(listener: (context, state) {
            if (state is LocationConnected) {
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
              return const CircularProgressIndicator();
            } else {
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
                          context
                              .read<LocationBloc>()
                              .add(StopSendingLocation());
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
          },
        ),
      ),
    );
  }

  void _scaffold(BuildContext context, message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

// import 'package:alerta_uaz/application/alert/alert_bloc.dart';
// import 'package:alerta_uaz/application/alert/alert_state.dart';
// import 'package:alerta_uaz/application/location/location_bloc.dart';
// import 'package:alerta_uaz/application/location/location_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AlertPage extends StatelessWidget {
//   const AlertPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, String> data =
//         ModalRoute.of(context)?.settings.arguments as Map<String, String>;

//     context
//         .read<LocationBloc>()
//         .add(StartSendingLocation(data['room']!, data['username']!));

//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Alerta activada'),
//           automaticallyImplyLeading: false,
//         ),
//         body: BlocListener<AlertBloc, AlertState>(
//           listener: (context, state) {
//             if (state is AlertSent) {
//               ScaffoldMessenger.of(context)
//                   .showSnackBar(SnackBar(content: Text(state.message)));
//             } else if (state is AlertSending) {
//               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                   content: Text('Enviando notificación a contactos')));
//             } else if (state is AlertError) {
//               ScaffoldMessenger.of(context)
//                   .showSnackBar(SnackBar(content: Text(state.error)));
//             }
//           },
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text('Activaste una alerta'),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 ElevatedButton(
//                     onPressed: () {
//                       context.read<LocationBloc>().add(StopSendingLocation());
//                       context.read<AlertBloc>().resumeListeningShake();
//                       WidgetsBinding.instance.addPostFrameCallback((_) {
//                         Navigator.of(context).pushReplacementNamed('/main');
//                       });
//                     },
//                     child: const Text('Desactivar alerta'))
//               ],
//             ),
//           ),
//         ));
//   }
// }
