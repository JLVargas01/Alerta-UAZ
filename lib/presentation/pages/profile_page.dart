import 'package:alerta_uaz/application/alert_bloc.dart';
import 'package:alerta_uaz/application/auth_bloc.dart';
import 'package:alerta_uaz/application/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/login');
            });
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is Authenticated) {
              final user = state.user;

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mostrar avatar si está disponible
                    if (user.avatar != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.avatar!),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NotificationBloc>().add(Disabled());
                        context.read<AlertBloc>().add(AlertDisabled());
                        context.read<AuthBloc>().add(SignOut());
                      },
                      child: const Text('Cerrar sesión'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('No hay información disponible'),
              );
            }
          },
        ),
      ),
    );
  }
}
