import 'package:flutter/material.dart';

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
      ),
      body: Center(
        child: Text(
          'Datos de la notificación: ${data['message']}',
        ),
      ),
    );
  }
}
