import 'package:flutter/material.dart';

class AlertPreferrence extends StatelessWidget {
  const AlertPreferrence({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Opciones de alerta')),
        body: const  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tienes la opción de enviar más información en caso de una alerta con las siguientes opciones',
                style: TextStyle(fontSize: 20),
              ),
              AlertPreferencePage(),
            ],
        ),
       ),
    );
  }
}

class AlertPreferencePage extends StatefulWidget {
  const AlertPreferencePage({super.key});

  @override
  State<AlertPreferencePage> createState() => _AlertPreferencePageState();
}

class _AlertPreferencePageState extends State<AlertPreferencePage> {
  bool light = true;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Enviar audios grabados durante una situación de peligro',
          style: TextStyle(fontSize: 18),
          ),
        Switch(
          thumbIcon: thumbIcon,
          value: light,
          onChanged: (bool value) {
            setState(() {
              light = value;
            });
          },
        ),
      ],
    );
  }

}
