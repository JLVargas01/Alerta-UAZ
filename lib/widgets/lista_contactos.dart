import 'package:alerta_uaz/conexion_conts.dart';
import 'package:alerta_uaz/models/receptor.dart';
import 'package:flutter/material.dart';

class ListTileExample extends StatelessWidget {
  const ListTileExample({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> listaDeContactos = ['Contacto 1', 'Contacto 2', 'Contacto 3'];
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de contactos')),

      //Lista de contactos
        body: ListView.builder(
        itemCount: listaDeContactos.length,
        itemBuilder: (context, index) {

          // Construir cada elemento de la lista dinámicamente
          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const FlutterLogo(size: 50.0),
              title: Text(listaDeContactos[index]),
              trailing: const Icon(Icons.more_vert),
            ),
          );
        },
      ),
    );
  }
}
