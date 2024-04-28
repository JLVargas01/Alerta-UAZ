import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

/// Callback for phone shakes
typedef PhoneShakeCallback = void Function();

/// ShakeDetector class for phone shake functionality
class ShakeDetectorService {
  bool _isPaused = false;
  int lastResumedTimeStamp = 0;

  /// User callback for phone shake
  final PhoneShakeCallback onShake;

  /// Shake detection threshold
  final double shakeThresholdGravity = 10.0;

  /// Minimum time between shake
  final int shakeSlopTimeMS = 5000;

  /// Time before shake count resets in milliseconds
  final int shakeCountResetTime = 3000;

  /// Number of shakes required before shake is triggered
  final int minimumShakeCount = 1;

  int mShakeTimestamp = DateTime.now().millisecondsSinceEpoch;
  int mShakeCount = 0;

  /// StreamSubscription for Accelerometer events
  StreamSubscription? streamSubscription;

  /// This constructor waits until [startListening] is called
  ShakeDetectorService.waitForStart({
    required this.onShake,
  });

  /// This constructor automatically calls [startListening] and starts detection and callbacks.
  ShakeDetectorService.autoStart({
    required this.onShake,
  }) {
    startListening();
  }

  /// Starts listening to accelerometer events
  void startListening() {
    streamSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        if (_isPaused) return;

        if (lastResumedTimeStamp + 500 >
            DateTime.now().millisecondsSinceEpoch) {
          return;
        }

        double x = event.x;
        double y = event.y;
        double z = event.z;

        double gX = x / 9.80665;
        double gY = y / 9.80665;
        double gZ = z / 9.80665;

        // gForce will be close to 1 when there is no movement.
        double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

        if (gForce > shakeThresholdGravity) {
          var now = DateTime.now().millisecondsSinceEpoch;
          // ignore shake events too close to each other (500ms)
          if (mShakeTimestamp + shakeSlopTimeMS > now) {
            return;
          }

          // reset the shake count after 3 seconds of no shakes
          if (mShakeTimestamp + shakeCountResetTime < now) {
            mShakeCount = 0;
          }

          mShakeTimestamp = now;
          mShakeCount++;

          if (mShakeCount >= minimumShakeCount) {
            onShake();
          }
        }
      },
    );
  }

  void pauseListening() {
    _isPaused = true;
    mShakeCount = 0;
    streamSubscription?.pause();
  }

  bool get isPaused {
    return _isPaused;
  }

  bool get isListening => !_isPaused;

  void resumeListening() {
    _isPaused = false;
    mShakeCount = 0;
    lastResumedTimeStamp = DateTime.now().millisecondsSinceEpoch;
    streamSubscription?.resume();
  }

  /// Stops listening to accelerometer events
  void stopListening() {
    _isPaused = true;
    streamSubscription?.cancel();
  }
}
