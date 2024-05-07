import 'package:alerta_uaz/api/google_sign_in_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({super.key});

  @override
  State<LoggedInPage> createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  late GoogleSignInAccount? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final currentUser = GoogleSignInService.getUser();
    setState(() {
      user = currentUser;
    });
  }

  void _handleSignOut(BuildContext context) {
    GoogleSignInService.logOut();
    Navigator.of(context).pushNamed('/singIn');
  }

  void _handleContactList() {
    Navigator.of(context).pushNamed('/contacts');
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.blue, fontSize: 20);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sesión iniciada', 
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () => _handleSignOut(context),
            child: const Text('Cerrar sesión'),
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Perfil',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            if (user != null) ...[
              Text(
                'Usuario: ${user!.displayName}',
                style: textStyle,
              ),
              const SizedBox(height: 5),
              Text(
                'Email: ${user!.email}',
                style: textStyle,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width / 2, 50),
                ),
                onPressed: _handleContactList,
                child: const Text('Contactos de confianza'),
              ),
            ] else
              const Text(
                'Usuario no encontrado',
                style: textStyle,
              ),
          ],
        ),
      ),
    );
  }
}
