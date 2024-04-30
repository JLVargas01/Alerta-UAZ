import 'dart:async';

import 'package:alerta_uaz/api/google_sign_in_service.dart';
import 'package:alerta_uaz/api/user_http_service.dart';
import 'package:alerta_uaz/pages/logged_in_screen.dart';
import 'package:alerta_uaz/services/usuario_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInUsuario extends StatefulWidget {
  ///
  const SignInUsuario({super.key});

  @override
  State createState() => _SignInUsuarioState();
}

class _SignInUsuarioState extends State<SignInUsuario> {

  Future<void> _handleSignIn() async {
    final user = await GoogleSignInService.logIn();
    if(user == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error en autenticacion'),));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoggedInPage(user: user),
      ));
    }
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
