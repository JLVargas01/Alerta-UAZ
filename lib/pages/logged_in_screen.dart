
import 'package:alerta_uaz/api/google_sign_in_service.dart';
import 'package:alerta_uaz/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoggedInPage extends StatelessWidget{
  final GoogleSignInAccount user;

  const LoggedInPage({
    super.key,
    required this.user,
  });

  Future<void> _handleSignOut(BuildContext context) async {
    GoogleSignInService.logOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const SignInUsuario(),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
   appBar: AppBar(
    title: const Text('Sesion iniciada'),
    centerTitle: true,
    actions: [
      TextButton(
        onPressed: ()=> _handleSignOut(context), 
        child: const Text('Cerrar sesion')
        )
    ]
   ),
   body: Container(
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Perfil',
        style: TextStyle(fontSize: 24),
        ),
        const SizedBox(height:24),
        Text(
          'Usuario: ${user.displayName}',
          style: const TextStyle(color: Colors.blue, fontSize: 20),
        ),
        const SizedBox(height:5),
        Text(
          'Email: ${user.email}',
          style: const TextStyle(color: Colors.blue, fontSize: 20),
        ),
      ],
    )
   ) 
  );
}