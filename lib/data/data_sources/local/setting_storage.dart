/*
/// SettingStorage gestiona el almacenamiento y recuperación de la configuración del usuario.
///
/// Esta clase utiliza 'SharedPreferences' para guardar y cargar ajustes relacionados
/// con la sensibilidad del dispositivo, el tiempo mínimo de detección y la intensidad de un evento de agitación.
///
/// Los datos almacenados incluyen:
/// - 'sensitivity': Nivel de sensibilidad (por defecto "Medio").
/// - 'minTime': Tiempo mínimo en segundos para detectar un evento (por defecto 5.0).
/// - 'shakeAmount': Intensidad mínima para detectar una agitación (por defecto 4.0).
*/

import 'package:alerta_uaz/domain/model/setting_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingStorage {
  late SharedPreferences _prefs;

  /// Carga la configuración del usuario desde 'SharedPreferences'.
  /// Retorna una instancia de 'Settings' con los valores almacenados o valores por defecto.
  Future<Settings> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    String sensitivity = _prefs.getString('sensitivity') ?? 'Medio';
    double minTime = _prefs.getDouble('minTime') ?? 5.0;
    double shakeAmount = _prefs.getDouble('shakeAmount') ?? 4.0;

    return Settings(
        sensitivity: sensitivity, minTime: minTime, shakeAmount: shakeAmount);
  }

  /// Guarda la configuración del usuario en 'SharedPreferences'.
  /// [settings] - Objeto 'Settings' que contiene los valores a almacenar.
  Future<void> saveSettings(Settings settings) async {
    await _prefs.setString('sensitivity', settings.getSensitivity);
    await _prefs.setDouble('minTime', settings.getMinTime);
    await _prefs.setDouble('shakeAmount', settings.getShakeAmount);
  }
}
