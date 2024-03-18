/*
* Este no se usa, guardado porque el diseño de la lista me gusta LOL
*/

import 'package:flutter/material.dart';

class ListTileExample extends StatelessWidget {

  const ListTileExample({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> listaDeContactos = ['Contacto 1', 'Contacto 2', 'Contacto 3', 'Contacto 4', 'Contacto 5'];
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
