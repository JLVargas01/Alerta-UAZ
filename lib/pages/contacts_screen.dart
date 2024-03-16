import 'package:alerta_uaz/services/contacts_db.dart';
import 'package:alerta_uaz/models/cont_confianza.dart';
import 'package:flutter/material.dart';

class ContactosPage extends StatefulWidget {
  const ContactosPage({super.key});

  @override
  State<ContactosPage> createState() => _ContactosPageState();

}

class _ContactosPageState extends State<ContactosPage> {

  Future<List<ContactoConfianza>>? futureContcs;
  final contcsDB = ContactosConfianza();

  void ferchContactos() {
    setState(() {
      futureContcs = contcsDB.contactos();
    });
  }

  @override
  void initState() {
    super.initState();
    ferchContactos();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Lista de contactos')),

    body: FutureBuilder<List<ContactoConfianza>>(
      future: futureContcs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final contactos = snapshot.data;

          return contactos!.isEmpty ?
            const Center(
              child: Text(
                'No hay contactos agregados',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ):
            ListView.separated(
              separatorBuilder:(context, index) => const SizedBox(height: 15),
              itemCount: contactos.length,
              itemBuilder:(context, index) {
                final contacto = contactos[index];
                return ListTile(
                  title: Text(
                  contacto.name,
                  style: const TextStyle(fontSize: 10)
                  ),
                );
              },
            );
        }
      }
    )
  );
  
}
