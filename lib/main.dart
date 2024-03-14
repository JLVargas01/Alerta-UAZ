import 'package:flutter/material.dart';

import 'widgets/lista_contactos.dart';

/// Flutter code sample for [ListTile].

void main() {
  runApp(const AppAlerta());
}

class AppAlerta extends StatelessWidget {
  const AppAlerta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const ListTileExample(),
    );
  }
}
