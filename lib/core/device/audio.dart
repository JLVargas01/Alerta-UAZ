import 'dart:async';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Audio {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _path;

  /// Captura y guarda los datos del audio en un archivo.
  Future<void> startAudioCapture(String fileName) async {
    PermissionStatus microphoneStatus = await Permission.microphone.status;

    // Si aún no se conseden los permisos para la captura de audio, preguntamos.
    if (!microphoneStatus.isGranted) {
      microphoneStatus = await Permission.microphone.request();

      // Si el usuario no quiere dar permisos, simplemente no grabamos el audio.
      if (!microphoneStatus.isGranted) return;
    }

    final directory = await getExternalStorageDirectory();

    final audioDirectory = Directory('${directory!.path}/Audio');

    if (!await audioDirectory.exists()) {
      await audioDirectory.create(recursive: true);
    }

    _path = '${audioDirectory.path}/$fileName.wav';

    await _recorder.openRecorder();

    await _recorder.startRecorder(
      toFile: _path,
      codec: Codec.pcm16WAV, // Codificación de 16 bits WAV
    );
  }

  /// Detiene la captura y retorna la fuente del archivo donde se grabo el audio.
  Future<String?> stopAudioCapture() async {
    if (!await Permission.microphone.isGranted) return null;

    await _recorder.stopRecorder();

    return _path;
  }
}
