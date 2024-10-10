import 'package:alerta_uaz/application/authentication/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión con Google'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).add(SignIn());
          },
          child: const Text('Iniciar sesión con Google'),
        ),
      ),
    );
  }
}
