import 'dart:async';

import 'package:alerta_uaz/api/user_http_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>[
  'email',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: scopes,
);

///**************************** Clase principal
class SignInUsuario extends StatefulWidget {
  ///
  const SignInUsuario({super.key});

  @override
  State createState() => _SignInUsuarioState();
}

class _SignInUsuarioState extends State<SignInUsuario> {
  GoogleSignInAccount? _currentUser; // Usuario
  bool _isAuthorized = false; // Permisos

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      bool isAuthorized = account != null;
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      }

      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

    });

    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print('\n\n******************Error************************');
      print(error);
      print('\n\n******************Error************************');
    }
  }

  Future<void> _handleAuthorizeScopes() async {
    final bool isAuthorized = await _googleSignIn.requestScopes(scopes);
    setState(() {
      _isAuthorized = isAuthorized;
    });
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      // The user is Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Iniciaste sesión exitosamente.'),
          if (!_isAuthorized) ...<Widget>[
            const Text('Se necesitan permisos adicionales para leer sus contactos.'),
            ElevatedButton(
              onPressed: _handleAuthorizeScopes,
              child: const Text('SOLICITAR PERMISOS'),
            ),
          ],
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('DESCONECTAR'),
          ),
        ],
      );
    } else {
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