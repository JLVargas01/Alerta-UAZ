import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertPreference extends StatelessWidget {
  const AlertPreference({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Opciones de alerta')),
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Tienes la opción de enviar más información durante una alerta con las siguientes preferencias',
                style: TextStyle(fontSize: 18),
              ),
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
  late SharedPreferences _prefs;
  bool _sendAudio = false;
  bool _sendVideo = false;

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
  void initState() {
    super.initState();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _sendAudio = _prefs.getBool('sendAudio') ?? false;
      _sendVideo = _prefs.getBool('sendVideo') ?? false;
    });
  }

  Future<void> _changeStateAudio(bool value) async {
    setState(() {
      _sendAudio = value;
    });
    await _prefs.setBool('sendAudio', value);
  }

  Future<void> _changeStateVideo(bool value) async {
    setState(() {
      _sendVideo = value;
    });
    await _prefs.setBool('sendVideo', value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        
        //Primer switch para la opcion de enviar audio
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Enviar audios grabados durante una situación de peligro',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Switch(
          thumbIcon: thumbIcon,
          value: _sendAudio,
          onChanged: (bool value) {
            _changeStateAudio(value);
          },
        ),

        //Segundo switch para la opcion de enviar video
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Enviar audios grabados durante una situación de peligro',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Switch(
          thumbIcon: thumbIcon,
          value: _sendVideo,
          onChanged: (bool value) {
            _changeStateVideo(value);
          },
        ),
      ],
    );
  }
}
