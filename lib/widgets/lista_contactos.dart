import 'package:flutter/material.dart';

class ListTileExample extends StatelessWidget {
  const ListTileExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de contactos')),

      //Lista de contactos
      body: ListView(
        children: const <Widget>[

          // Cartas de contactos
          Card(
            elevation: 3, 
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: FlutterLogo(size: 50.0,),
              title: Text('Nombre contacto'),
              trailing: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
    );
  }
}
