import 'dart:async';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Audio {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _audio;

  /// Captura y guarda los datos del audio en un archivo WAV.
  Future<void> startAudioCapture(String newFile) async {
    PermissionStatus microphoneStatus = await Permission.microphone.status;

    // Si aún no se conseden los permisos para la captura de audio, preguntamos.
    if (!microphoneStatus.isGranted) {
      microphoneStatus = await Permission.microphone.request();

      // Si el usuario no quiere dar permisos, simplemente no grabamos el audio.
      if (!microphoneStatus.isGranted) return;
    }

    final audioDirectory = await getAudioPath();

    _audio = '$audioDirectory/$newFile.wav';

    await _recorder.openRecorder();

    await _recorder.startRecorder(
      toFile: _audio,
      codec: Codec.pcm16WAV, // Codificación de 16 bits WAV
    );
  }

  /// Detiene la captura y retorna la fuente del archivo donde se grabo el audio.
  Future<String?> stopAudioCapture() async {
    if (!await Permission.microphone.isGranted) return null;

    await _recorder.stopRecorder();

    return _audio;
  }

  Future<File?> checkAudio(String filename) async {
    final audioDirectory = await getAudioPath();

    final path = '$audioDirectory/$filename';

    File file = File(path);

    return file.existsSync() ? file : null;
  }

  /// Retorna el directorio donde se almacenan los audios
  Future<String> getAudioPath() async {
    final directory = await getApplicationDocumentsDirectory();

    final audioDirectory = Directory('${directory.path}/audio');
    // Creamos el directorio si no existe
    if (!await audioDirectory.exists()) {
      await audioDirectory.create(recursive: true);
    }

    return audioDirectory.path;
  }
}
