import 'dart:async';
import 'package:alerta_uaz/api/google_sign_in_service.dart';
import 'package:alerta_uaz/pages/logged_in_screen.dart';
import 'package:alerta_uaz/services/usuario_service.dart';
import 'package:flutter/material.dart';

class SignInUsuario extends StatefulWidget {
  const SignInUsuario({super.key});

  @override
  State<StatefulWidget> createState() => _SignInUsuarioState();
}

class _SignInUsuarioState extends State<SignInUsuario> {
  late UsuarioServices serviciosUsuario;

Future<void> _handleSignIn() async {
  final user = await GoogleSignInService.logIn();
  if (user == null) {
    if (mounted) { // Verifica si el widget está montado antes de mostrar la Snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error en la autenticación'),
      ));
    }
  } else {
    final elEmail = user.email;
    final elNombre = user.displayName ?? '';
    serviciosUsuario.inicioSesionApi(elEmail, elNombre);
    if (mounted) { // Verifica si el widget está montado antes de realizar la navegación
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoggedInPage(user: user),
      ));
    }
  }
}

  @override
  void initState() {
    super.initState();
    serviciosUsuario = UsuarioServices();
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        const Text('Actualmente no estás registrado.'),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width / 2, 50),
          ),
          onPressed: _handleSignIn,
          child: const Text('Iniciar sesión'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      )
    );
  }
}
