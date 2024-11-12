import 'package:alerta_uaz/domain/model/setting_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingStorage {
  late SharedPreferences _prefs;

  Future<Settings> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    String sensitivity = _prefs.getString('sensitivity') ?? 'Medio';
    double minTime = _prefs.getDouble('minTime') ?? 5.0;
    double shakeAmount = _prefs.getDouble('shakeAmount') ?? 4.0;

    return Settings(
        sensitivity: sensitivity, minTime: minTime, shakeAmount: shakeAmount);
  }

  Future<void> saveSettings(Settings settings) async {
    await _prefs.setString('sensitivity', settings.getSensitivity);
    await _prefs.setDouble('minTime', settings.getMinTime);
    await _prefs.setDouble('shakeAmount', settings.getShakeAmount);
  }
}
