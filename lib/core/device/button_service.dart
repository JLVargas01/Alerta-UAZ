import 'package:android_physical_buttons/android_physical_buttons.dart';
import 'package:vibration/vibration.dart';

/*
//  Servicio para la detección de pulsaciones en los botones físicos del dispositivo.
//  La clase 'ButtonService' permite escuchar las pulsaciones de los botones físicos, 
//  específicamente los botones de volumen. Cuando el usuario presiona el botón de 
//  volumen varias veces dentro de un tiempo determinado, se activa una acción 
//  definida por el usuario mediante un 'Handler'. 
//  Funcionalidades principales:
// -Escucha eventos de los botones físicos del dispositivo con 'android_physical_buttons'.
// -Detecta una secuencia rápida de pulsaciones en los botones de volumen.
// -Ejecuta una acción cuando se alcanza un número mínimo de pulsaciones.
// -Puede vibrar el dispositivo al detectar la secuencia.
// -Permite pausar y reanudar la detección de eventos.
*/

typedef Handler = void Function();

class ButtonService {
  bool _isPaused = false;

  Handler? _onHanlder;

  final int _minimumVolumeButtonCount = 3;  // Número mínimo de pulsaciones requeridas

  // Se podría usar para botones de encendido
  int _volumeButtonCount = 0;

  int _startTime = 0;
  int _lastResumedTimeStamp = 0;
  final int _buttonSlopTimeMS = 100;  // Tiempo mínimo entre pulsaciones válidas (en ms)
  final int _totalTimeForButtons = 5000;
  int _buttonTimeStamp = DateTime.now().millisecondsSinceEpoch;

  /// Inicia la escucha de eventos en los botones físicos del dispositivo.
  /// [handler] es la función que se ejecutará cuando se detecte la secuencia de pulsaciones.
  void startListening(Handler handler) {
    _onHanlder = handler;

    AndroidPhysicalButtons.listen((key) {
      if (_isPaused) return;

      if (_lastResumedTimeStamp + 500 > DateTime.now().millisecondsSinceEpoch) {
        return;
      }

      var now = DateTime.now().millisecondsSinceEpoch;

      // Reinicia el contador en caso de haber sobrepasado el tiempo permitido
      if (_startTime != 0 && (now - _startTime > _totalTimeForButtons)) {
        _volumeButtonCount = 0;
        _startTime = 0;
      }

      if (_buttonTimeStamp + _buttonSlopTimeMS > now) {
        return;
      }

      _buttonTimeStamp = now;
      if (_volumeButtonCount == 0) {
        _startTime = now;
      }

      _volumeButtonCount++;

      if (_volumeButtonCount >= _minimumVolumeButtonCount) {
        Vibration.vibrate(duration: 1000);
        _onHanlder?.call();
        _volumeButtonCount = 0;
        _startTime = 0;
      }
    });
  }

  /// Pausa la escucha de eventos de los botones físicos.
  /// Detiene la detección de pulsaciones hasta que se reanude con 'resumeListening()'.
  void pauseListening() {
    _isPaused = true;
    _volumeButtonCount = 0;
  }

  /// Reanuda la escucha de eventos de los botones físicos.
  /// Restablece el contador y permite detectar pulsaciones nuevamente.
  void resumeListening() {
    _isPaused = false;
    _volumeButtonCount = 0;
    _lastResumedTimeStamp = DateTime.now().millisecondsSinceEpoch;
  }

  /// Detiene la escucha de eventos y reinicia los contadores
  void stopListening() {
    _isPaused = false;
    _volumeButtonCount = 0;
  }
}
