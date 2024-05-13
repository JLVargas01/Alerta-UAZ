import 'dart:async';
import 'package:alerta_uaz/api/google_sign_in_service.dart';
import 'package:alerta_uaz/services/usuario_service.dart';
import 'package:flutter/material.dart';

class SignInUsuario extends StatefulWidget {
  const SignInUsuario({super.key});

  @override
  State<StatefulWidget> createState() => _SignInUsuarioState();
}

class _SignInUsuarioState extends State<SignInUsuario> {
  late UsuarioServices serviciosUsuario;
  bool _isLoading = false;

Future<void> _handleSignIn() async {
  setState(() {
    _isLoading = true;
  });
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
    bool respuesta = await serviciosUsuario.inicioSesionApi(elEmail, elNombre);
    if (mounted) { // Verifica si el widget está montado antes de realizar la navegación
      /* Hacer algo si no se pudo conectar al servidor
      if(!respuesta) { //Hay un error
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error durante el inicio de sesión'),
        ));
      } else {
        Navigator.of(context).pushNamed('/main', arguments: user);
      }
      */
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }
}

  @override
  void initState() {
    super.initState();
    serviciosUsuario = UsuarioServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _isLoading ? _buildLoadingIndicator() : _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Actualmente no estás registrado.'),
        const SizedBox(height: 20),
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

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
