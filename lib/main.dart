import 'package:flutter/material.dart';

import 'pages/contacts_screen.dart';
import 'pages/pref_alerta_screen.dart';

void main() {
  runApp(const AppAlerta());
}

class AppAlerta extends StatelessWidget {
  const AppAlerta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const AlertPreferrence(),
    );
  }
}
