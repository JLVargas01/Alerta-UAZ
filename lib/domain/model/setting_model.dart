class Settings {
  String _sensitivity;
  double _minTime;
  double _shakeAmount;

  Settings({required sensitivity, required minTime, required shakeAmount})
      : _sensitivity = sensitivity,
        _minTime = minTime,
        _shakeAmount = shakeAmount;

  String get getSensitivity => _sensitivity;
  double get getMinTime => _minTime;
  double get getShakeAmount => _shakeAmount;

  void setSensitivity(String newValue) {
    _sensitivity = newValue;
  }

  void setMinTime(double newValue) {
    _minTime = newValue;
  }

  void setShakeAmount(double newValue) {
    _shakeAmount = newValue;
  }

  @override
  String toString() {
    return '{ sensitivity: $_sensitivity, time: $_minTime, shake: $_shakeAmount}';
  }
}
