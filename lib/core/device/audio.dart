import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';

class Audio {
  // Captura audio desde el microfono del dispositivo
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  // Reproduce datos (chunks) de un audio
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  // Stream para recibir y enviar los datos (chunks)
  late StreamController<FoodData> _audioStreamController;

  Stream<FoodData> get streamAudio => _audioStreamController.stream;

  //--------------------- CAPTURA DE AUDIO

  /// Inicializa la captura de audio, teniendo acceso al
  /// microfono del dispositivo y capturando los chunks desde el StreamController
  Future<void> startAudioCapture() async {
    _audioStreamController = StreamController<FoodData>();
    await _recorder.openRecorder();

    await _recorder.startRecorder(
      toStream: _audioStreamController.sink,
      codec: Codec.pcm16, // Codificación de 16 bits
    );
  }

  /// Detiene la captura del audio, dejando de tener acceso temporal
  /// al microfono del dispositivo y cerrando temporalmente el StreamController
  Future<void> stopAudioCapture() async {
    await _recorder.stopRecorder();
    await _audioStreamController.close();
  }

  //--------------------- REPRODUCIÓN DE AUDIO

  Future<void> startPlayAudioCapture() async {
    await _player.openPlayer();
    await _player.startPlayerFromStream();
  }

  Future<void> playAudioCapture(dynamic data) async {
    if (_player.isOpen()) await _player.feedFromStream(data);
  }

  Future<void> stopPlayAudioCapture() async {
    await _player.stopPlayer();
  }
}
