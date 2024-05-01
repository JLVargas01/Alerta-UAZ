import 'package:alerta_uaz/pages/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AppAlerta());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppAlerta extends StatelessWidget {
  const AppAlerta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const SignInUsuario(),
    );
  }
}
