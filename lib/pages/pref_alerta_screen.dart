import 'package:flutter/material.dart';

class AlertPreferrence extends StatelessWidget {
  const AlertPreferrence({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Opciones de alerta')),
        body: const  Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alineación del texto a la izquierda
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

  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Color?> trackColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.amber;
        }
        return null;
      },
    );

    final MaterialStateProperty<Color?> overlayColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.amber.withOpacity(0.54);
        }
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey.shade400;
        }
        return const Color.fromARGB(100, 0, 0, 0);
      },
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              side: BorderSide(width: 1, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            child: Switch(
              value: light,
              overlayColor: overlayColor,
              trackColor: trackColor,
              onChanged: (bool value) {
                setState(() {
                  light = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
