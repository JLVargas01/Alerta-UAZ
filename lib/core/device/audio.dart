import 'dart:async';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/*
  Gestión de grabación y almacenamiento de audio en la aplicación.

  La clase 'Audio' proporciona métodos para capturar, detener y verificar la 
  existencia de archivos de audio grabados. Utiliza 'flutter_sound' para la 
  grabación y 'path_provider' para gestionar la ubicación de almacenamiento. 
  También maneja permisos de micrófono con 'permission_handler'.

  Funcionalidades principales:
  - Solicita permisos para acceder al micrófono.
  - Graba audio y lo guarda en formato WAV.
  - Detiene la grabación y retorna la ubicación del archivo guardado.
  - Verifica la existencia de archivos de audio en el almacenamiento.
  - Obtiene o crea el directorio donde se almacenan los archivos de audio.
*/
class Audio {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _audio;

  /// Inicia la grabación de audio y lo guarda como un archivo WAV.
  ///
  /// [newFile] es el nombre del archivo sin extensión.
  /// Antes de grabar, solicita permisos para usar el micrófono.
  Future<void> startAudioCapture(String newFile) async {
    PermissionStatus microphoneStatus = await Permission.microphone.status;

    // Si aún no se conceden los permisos para la captura de audio, los solicita.
    if (!microphoneStatus.isGranted) {
      microphoneStatus = await Permission.microphone.request();

      // Si el usuario no otorga permisos, se cancela la grabación.
      if (!microphoneStatus.isGranted) return;
    }

    final audioDirectory = await getAudioPath();
    _audio = '$audioDirectory/$newFile.wav';

    await _recorder.openRecorder();

    await _recorder.startRecorder(
      toFile: _audio,
      codec: Codec.pcm16WAV, // Codificación de 16 bits en formato WAV.
    );
  }

  /// Detiene la grabación de audio y devuelve la ruta del archivo generado.
  ///
  /// Retorna 'null' si no se han concedido permisos para el micrófono.
  Future<String?> stopAudioCapture() async {
    if (!await Permission.microphone.isGranted) return null;

    await _recorder.stopRecorder();

    return _audio;
  }

  /// Verifica si un archivo de audio con el nombre [filename] existe en el almacenamiento.
  ///
  /// Retorna el archivo si existe o 'null' si no se encuentra.
  Future<File?> checkAudio(String filename) async {
    final audioDirectory = await getAudioPath();
    final path = '$audioDirectory/$filename';

    File file = File(path);
    return file.existsSync() ? file : null;
  }

  /// Obtiene la ruta del directorio donde se almacenan los archivos de audio.
  ///
  /// Si el directorio no existe, lo crea antes de retornar su ruta.
  Future<String> getAudioPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDirectory = Directory('${directory.path}/audio');

    // Crea el directorio si aún no existe
    if (!await audioDirectory.exists()) {
      await audioDirectory.create(recursive: true);
    }

    return audioDirectory.path;
  }
}
