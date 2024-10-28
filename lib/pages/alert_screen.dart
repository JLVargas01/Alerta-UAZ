// import 'dart:async';
// import 'package:alerta_uaz/main.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:alerta_uaz/services/location_service.dart';
// import 'package:alerta_uaz/services/shake_detector_service.dart';
// import 'package:alerta_uaz/services/socket_service.dart';
// import 'package:alerta_uaz/pages/contacts_screen.dart';

// class AlertPage extends StatefulWidget {
//   const AlertPage({super.key});

//   @override
//   State<AlertPage> createState() => _AlertPageState();
// }

// class _AlertPageState extends State<AlertPage> {
//   Timer? _timer;
//   final LocationService locationService = LocationService();
//   final SocketService socketService = SocketService();
//   String errorMessage = '';
//   bool isOnline = true;

//   @override
//   void initState() {
//     super.initState();
//     socketService.onStatusChanged =
//         _handleConnectionChange; // Escucha cambios de estado de conexión
//     sendLocation(); // Inicia el envío periódico de la ubicación
//   }

//   void _handleConnectionChange(bool connected, String message) {
//     setState(() {
//       isOnline = connected;
//       errorMessage = message;
//     });
//     if (connected) {
//       sendLocation(); // Reinicia el envío de ubicación al reconectar
//     } else {
//       _timer?.cancel(); // Detiene el envío si se pierde la conexión
//     }
//   }

//   void sendLocation() {
//     _timer?.cancel(); // Previene la creación de múltiples timers
//     _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
//       try {
//         if (!socketService.isConnected()) {
//           // throw Exception('No hay conexión a internet.');
//           errorMessage = 'No hay conexión a internet.';
//           return;
//         }
//         Position position = await locationService.getCurrentLocation();
//         socketService.emit('location',
//             {'latitude': position.latitude, 'longitude': position.longitude});
//       } catch (e) {
//         setState(() {
//           errorMessage = e.toString();
//           isOnline = false;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(child: Text('Alerta Activada')),
//       ),
//       body: Column(
//         children: [
//           _buildConnectionErrorBar(),
//           _buildContent(),
//         ],
//       ),
//     );
//   }

//   Widget _buildConnectionErrorBar() {
//     return isOnline
//         ? const SizedBox.shrink()
//         : Container(
//             color: Colors.red,
//             width: double.infinity,
//             padding: const EdgeInsets.all(8),
//             child:
//                 Text(errorMessage, style: const TextStyle(color: Colors.white)),
//           );
//   }

//   Widget _buildContent() {
//     return Expanded(
//       child: Center(
//         child: GestureDetector(
//           onTap: () {
//             ShakeDetectorService.resumeListening();
//             Navigator.pushNamed(context, '/contactos'); // Aquí cambiamos a Navigator.pushNamed
//           },
//           child: Container(
//             width: 200,
//             height: 200,
//             decoration:
//                 BoxDecoration(color: Colors.blue[300], shape: BoxShape.circle),
//             child: const Center(
//               child: Text('Desactivar alerta',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     socketService
//         .dispose(); // Asegura que los recursos del servicio de socket se liberan correctamente
//     super.dispose();
//   }
// }
