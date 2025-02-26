/// Representa la configuración de detección de sacudidas en la aplicación.
/// Contiene parámetros ajustables como sensibilidad, tiempo mínimo entre sacudidas y la cantidad de sacudidas necesarias.
/// Nota: Este codigo no se utiliza
/// $ComentarioPorRevisar
class Settings {
  /// Sensibilidad de la detección de sacudidas (puede ser un valor como "baja", "media" o "alta").
  String _sensitivity;

  /// Tiempo mínimo (en segundos) que debe transcurrir entre detecciones de sacudidas.
  double _minTime;

  /// Cantidad mínima de sacudidas requeridas para activar una acción.
  double _shakeAmount;

  /// Constructor de la clase 'Settings'.
  ///
  /// [sensitivity] Define el nivel de sensibilidad de la detección.
  /// [minTime] Establece el tiempo mínimo entre detecciones.
  /// [shakeAmount] Define la cantidad mínima de sacudidas requeridas.
  Settings({required sensitivity, required minTime, required shakeAmount})
      : _sensitivity = sensitivity,
        _minTime = minTime,
        _shakeAmount = shakeAmount;

  /// Obtiene el nivel de sensibilidad de la detección de sacudidas.
  String get getSensitivity => _sensitivity;

  /// Obtiene el tiempo mínimo requerido entre sacudidas.
  double get getMinTime => _minTime;

  /// Obtiene la cantidad mínima de sacudidas necesarias para activar una acción.
  double get getShakeAmount => _shakeAmount;

  /// Establece un nuevo valor para la sensibilidad de la detección de sacudidas.
  /// [newValue] Nuevo nivel de sensibilidad.
  void setSensitivity(String newValue) {
    _sensitivity = newValue;
  }

  /// Establece un nuevo valor para el tiempo mínimo entre detecciones.
  /// [newValue] Nuevo valor en segundos.
  void setMinTime(double newValue) {
    _minTime = newValue;
  }

  /// Establece un nuevo valor para la cantidad mínima de sacudidas requeridas.
  /// [newValue] Nueva cantidad de sacudidas necesarias.
  void setShakeAmount(double newValue) {
    _shakeAmount = newValue;
  }

  /// Representación en cadena de la configuración, útil para depuración y logs.
  /// [return] Una cadena con la configuración actual de sensibilidad, tiempo y sacudidas.
  @override
  String toString() {
    return '{ sensitivity: $_sensitivity, time: $_minTime, shake: $_shakeAmount}';
  }
}
