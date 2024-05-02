import 'dart:async';

import 'package:alerta_uaz/main.dart';
import 'package:alerta_uaz/pages/contacts_screen.dart';
import 'package:alerta_uaz/services/location_service.dart';
import 'package:alerta_uaz/services/shake_detector_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  Timer? _timer;
  LocationService locationService = LocationService();

  Map<String, dynamic> positionToJson(Position position) {
    return {'latitude': position.latitude, 'longitude': position.longitude};
  }

  void sendLocation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        Position position = await locationService.getCurrentLocation();
        socket.emit('location', positionToJson(position));
      } catch (e) {
        print('Error: $e');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    sendLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Alerta Activada'),
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            ShakeDetectorService.resumeListening();
            navigatorKey.currentState?.pushReplacement(
                MaterialPageRoute(builder: (_) => const ContactosPage()));
          },
          child: Container(
            width: 200,
            height: 200,
            decoration:
                BoxDecoration(color: Colors.blue[300], shape: BoxShape.circle),
            child: const Center(
              child: Text(
                'Desactivar alerta',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
