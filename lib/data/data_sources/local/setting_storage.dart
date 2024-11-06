import 'package:alerta_uaz/domain/model/setting_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingStorage {
  late SharedPreferences _prefs;
  late Settings _settings;

  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    String sensitivity = _prefs.getString('sensitivity') ?? 'Medio';
    double minTime = _prefs.getDouble('minTime') ?? 5.0;
    double shakeAmount = _prefs.getDouble('shakeAmount') ?? 4.0;

    _settings = Settings(
        sensitivity: sensitivity, minTime: minTime, shakeAmount: shakeAmount);
  }

  Future<void> saveSettings() async {
    await _prefs.setString('sensitivity', _settings.getSensitivity);
    await _prefs.setDouble('minTime', _settings.getMinTime);
    await _prefs.setDouble('shakeAmount', _settings.getShakeAmount);
  }

  Settings get getSettings => _settings;

  void setSettings(Settings settings) {
    _settings = settings;
  }
}
