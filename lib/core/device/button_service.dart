import 'package:android_physical_buttons/android_physical_buttons.dart';
import 'package:vibration/vibration.dart';

typedef Handler = void Function();

class ButtonService {
  bool _isPaused = false;

  Handler? _onHanlder;

  final int _minimumVolumeButtonCount = 3;
  // int _minimumPowerButtonCount = 2;

  int _volumeButtonCount = 0;
  // int _powerButtonCount = 0;

  int _startTime = 0;
  int _lastResumedTimeStamp = 0;
  final int _buttonSlopTimeMS = 100;
  final int _totalTimeForButtons = 5000;
  int _buttonTimeStamp = DateTime.now().millisecondsSinceEpoch;

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

  void pauseListening() {
    _isPaused = true;
    _volumeButtonCount = 0;
  }

  void resumeListening() {
    _isPaused = false;
    _volumeButtonCount = 0;
    _lastResumedTimeStamp = DateTime.now().millisecondsSinceEpoch;
  }

  void stopListening() {
    _isPaused = false;
    _volumeButtonCount = 0;
  }
}
