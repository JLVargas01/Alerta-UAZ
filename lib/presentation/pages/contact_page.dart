import 'package:alerta_uaz/presentation/pages/complete_phone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alerta_uaz/application/contact-list_bloc.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>  {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos'),
      ),
      body: BlocListener<ContactsBloc, ContactsState>(
  listener: (context, state) {
          if (state is NavigateToCompletePhonePage) {
            final contactsBloc = context.read<ContactsBloc>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompletePhonePage(
                  initialPhoneNumber: state.initialPhoneNumber,
                  contactName: state.nameContact,
                ),
              ),
            ).then((_) {
              contactsBloc.add(ResetNavigationState());
            });
          } else if (state is ContactAddedSuccessfully) {
            // Recarga los contactos al regresar
            context.read<ContactsBloc>().add(LoadContacts());
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
                          // Mostrar el mensaje de confirmación
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('Eliminar contacto'),
                                content: const Text('¿Deseas eliminar este contacto?'),
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
                                      context.read<ContactsBloc>().add(RemoveContact(contacto.id_confianza));
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
              context.read<ContactsBloc>().add(LoadContacts());
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
