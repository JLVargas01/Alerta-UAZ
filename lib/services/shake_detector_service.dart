import 'package:flutter/services.dart';

class ShakeDetectorService {
  static late final MethodChannel _channel;
  static void Function()? _onShakeCallback;

  static void initialize() {
    _channel = const MethodChannel('com.example.alerta_uaz/shake');
    _channel.setMethodCallHandler(_handleMethod);
  }

  // Método para establecer el listener que se activará cuando se detecte una agitación.
  static void setOnShakeListener(void Function() callback) {
    _onShakeCallback = callback;
  }

  // Método para eliminar el listener
  static void removeOnShakeListener() {
    _onShakeCallback = null;
  }

  // Método para manejar las llamadas que llegan del código nativo.
  static Future<void> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onShake":
        // Haz algo cuando se detecta una agitación, como llamar a un callback.
        if (_onShakeCallback != null) {
          _onShakeCallback!();
        }
        break;
      default:
        throw UnsupportedError("Unrecognized JSON message");
    }
  }

  static Future<void> updateShakeSensitivity(double sensitivity) async {
    await _channel
        .invokeMethod('updateShakeSensitivity', {'sensitivity': sensitivity});
  }

  static Future<void> updateContinuousShakeTime(int duration) async {
    await _channel
        .invokeMethod('updateContinuousShakeTime', {'duration': duration});
  }
}
