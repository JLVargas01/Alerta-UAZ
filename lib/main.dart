import 'package:alerta_uaz/pages/contacts_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AppAlerta());
}

class AppAlerta extends StatelessWidget {
  const AppAlerta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const ContactosPage(),
    );
  }
}
