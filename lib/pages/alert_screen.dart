import 'package:flutter/material.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Alerta Activada'),
        ),
      ),
      body: const Center(
        child: Text('Se activo una alerta'),
      ),
    );
  }
}
