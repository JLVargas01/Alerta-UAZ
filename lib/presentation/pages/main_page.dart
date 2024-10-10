import 'package:alerta_uaz/application/authentication/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          TextButton(
            onPressed: () => context.read<AuthBloc>().add(SignOut()),
            child: const Text('Cerrar sesión'),
          )
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(listener: (context, state) {
        if (state is Unauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/login');
          });
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        }
      }, child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(child: Text('Iniciaste sesión'));
          }
        },
      )),
    );
  }
}
