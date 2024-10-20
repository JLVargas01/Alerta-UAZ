import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alerta_uaz/application/contact-list_bloc.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos'),
      ),
      body: BlocListener<ContactsBloc, ContactsState>(
        listener: (context, state) {
          if (state is ContactsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: BlocBuilder<ContactsBloc, ContactsState>(
          builder: (context, state) {
            if (state is ContactsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ContactsLoaded) {
              final contactos = state.contactos;
              return contactos.isEmpty ? const Center(
                child: Text(
                  'No hay contactos agregados',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )
              : ListView.builder(
                itemCount: contactos.length,
                itemBuilder: (context, index) {
                  final contacto = contactos[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: const Icon(Icons.person, size: 50.0, color: Colors.blue),
                      title: Text(
                        contacto.alias,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline_outlined),
                        onPressed: () {
                          context.read<ContactsBloc>().add(RemoveContact(contacto.id_confianza));
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              context.read<ContactsBloc>().add(LoadContacts());
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.read<ContactsBloc>().add(AddContact());
        },
        tooltip: 'Agregar nuevo contacto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
