import 'package:alerta_uaz/application/contact/contact_bloc.dart';
import 'package:alerta_uaz/application/contact/contact_event.dart';
import 'package:alerta_uaz/application/contact/contact_state.dart';
import 'package:alerta_uaz/presentation/pages/complete_phone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    super.initState();
    context.read<ContactsBloc>().add(LoadContactList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos'),
      ),
      body: BlocListener<ContactsBloc, ContactsState>(
        listener: (context, state) async {
          if (state is NavigateToCompletePhonePage) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompletePhonePage(
                  initialPhoneNumber: state.initialPhoneNumber,
                  contactName: state.nameContact,
                ),
              ),
            );
          } else if (state is ContactAddedSuccessfully) {
            // Recarga los contactos al regresar
            context.read<ContactsBloc>().add(LoadContactList());
          } else if (state is ContactsError) {
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
              return contactos.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay contactos agregados',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
                            leading: const Icon(Icons.person,
                                size: 50.0, color: Colors.blue),
                            title: Text(
                              contacto.alias,
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                  Icons.remove_circle_outline_outlined),
                              onPressed: () {
                                // Mostrar el mensaje de confirmación
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: const Text('Eliminar contacto'),
                                      content: const Text(
                                          '¿Deseas eliminar este contacto?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            // Cerrar el diálogo sin realizar ninguna acción
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context.read<ContactsBloc>().add(
                                                RemoveContact(
                                                    contacto.contactId));
                                            // Cerrar el diálogo
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: const Text('Eliminar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.read<ContactsBloc>().add(SelectContact());
        },
        tooltip: 'Agregar nuevo contacto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
