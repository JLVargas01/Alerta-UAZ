// MIT License

// Copyright (c) 2024 Folksable

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// NOTA FINAL: Este codigo no se utiliza

import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';

typedef PhoneShakeCallback = void Function();

class ShakeDetector {
  // Singleton
  static final ShakeDetector _instance = ShakeDetector._internal();
  ShakeDetector._internal();
  factory ShakeDetector() => _instance;

  bool _isPaused = false;

  int _lastResumedTimeStamp = 0;

  PhoneShakeCallback? _onShake;

  double _shakeThresholdGravity = 2.7;
  // Mínimo de sacudidas necesarias dentro del tiempo permitido
  int _minimumShakeCount = 2;
  // Tiempo mínimo entre sacudidas
  final int _shakeSlopTimeMS = 1000;

  int _mShakeTimestamp = DateTime.now().millisecondsSinceEpoch;

  int _mShakeCount = 0;

  StreamSubscription? _streamSubscription;
  // Tiempo total permitido para detectar las sacudidas
  int _totalTimeForShakes = 5000;

  int _startTime = 0;

  void startListening(PhoneShakeCallback shakeCallback) {
    _onShake = shakeCallback;
    _streamSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        if (_isPaused) return;

        if (_lastResumedTimeStamp + 500 >
            DateTime.now().millisecondsSinceEpoch) {
          return;
        }

        var now = DateTime.now().millisecondsSinceEpoch;

        if (_startTime != 0 && (now - _startTime > _totalTimeForShakes)) {
          _mShakeCount = 0;
          _startTime = 0;
        }

        double x = event.x;
        double y = event.y;
        double z = event.z;

        double gX = x / 9.80665;
        double gY = y / 9.80665;
        double gZ = z / 9.80665;

        // gForce will be close to 1 when there is no movement.
        double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

        if (gForce > _shakeThresholdGravity) {
          // ignore shake events too close to each other (500ms)
          if (_mShakeTimestamp + _shakeSlopTimeMS > now) {
            return;
          }

          _mShakeTimestamp = now;
          if (_mShakeCount == 0) {
            _startTime = now;
          }

          _mShakeCount++;

          if (_mShakeCount >= _minimumShakeCount) {
            Vibration.vibrate(duration: 500);
            _onShake?.call();
            _mShakeCount = 0;
            _startTime = 0;
          } else {
            Vibration.vibrate(duration: 100);
          }
        }
      },
    );
  }

  void pauseListening() {
    _isPaused = true;
    _mShakeCount = 0;
    _streamSubscription?.pause();
  }

  void resumeListening() {
    _isPaused = false;
    _mShakeCount = 0;
    _lastResumedTimeStamp = DateTime.now().millisecondsSinceEpoch;
    _streamSubscription?.resume();
  }

  void stopListening() {
    _isPaused = false;
    _streamSubscription?.cancel();
  }

  bool get isPaused => _isPaused;
  bool get isListening => _isPaused;

  void setSettingsShake(
      String sensitivity, double minTime, double shakeAmount) {
    if (sensitivity == 'Alto') {
      _shakeThresholdGravity = 0.8 * 2.7;
    } else if (sensitivity == 'Medio') {
      _shakeThresholdGravity = 1.5 * 2.7;
    } else {
      _shakeThresholdGravity = 2.5 * 2.7;
    }

    _totalTimeForShakes = (minTime.toInt()) * 1000;

    _minimumShakeCount = shakeAmount.toInt();
  }
}
