import 'package:alerta_uaz/services/contacts_db.dart';
import 'package:alerta_uaz/models/cont_confianza.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

class ContactosPage extends StatefulWidget {
  const ContactosPage({super.key});

  @override
  State<ContactosPage> createState() => _ContactosPageState();
}

class _ContactosPageState extends State<ContactosPage> {
  Future<List<ContactoConfianza>>? futureContcs;
  final contcsDB = ContactosConfianza();

  void fetchContactos() {
    setState(() {
      futureContcs = contcsDB.contactos();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchContactos();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Lista de contactos')),
    body: FutureBuilder<List<ContactoConfianza>>(
      future: futureContcs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          );
        } else {
          final contactos = snapshot.data;
          return contactos == null || contactos.isEmpty?
            const Center(
              child: Text(
                'No hay contactos agregados',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ):

            // Lista de contactos
            ListView.builder(
              itemCount: contactos.length,
              itemBuilder: (context, index) {
                final contacto = contactos[index];

                // Construir cada elemento de la lista dinámicamente
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const FlutterLogo(size: 50.0),
                    title: Text(
                      contacto.name,
                      style: const TextStyle(fontSize: 16),
                    )
                  ),
                );
              },
            );
        }
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final PhoneContact contactPicker = await FlutterContactPicker.pickPhoneContact();
        String numeroTelefonico = contactPicker.phoneNumber.toString();
        String nombreCompleto = contactPicker.fullName.toString();
        ContactoConfianza nuevoContacto = ContactoConfianza(telephone: numeroTelefonico, name: nombreCompleto);
        contcsDB.insertContacto(nuevoContacto);
        setState(() {
          futureContcs = contcsDB.contactos();
        });
      },
      tooltip: 'Agregar nuevo contacto',
      child: const Icon(Icons.add),
    ),
  );
}
