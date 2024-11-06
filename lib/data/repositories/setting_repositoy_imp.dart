import 'package:alerta_uaz/data/data_sources/local/setting_storage.dart';
import 'package:alerta_uaz/data/data_sources/remote/shake_detector_service.dart';
import 'package:alerta_uaz/domain/model/setting_model.dart';
import 'package:alerta_uaz/domain/repositories/setting_repository.dart';

class SettingRepositoyImp implements SettingRepository {
  final SettingStorage _settingStorage = SettingStorage();
  final ShakeDetector _shake = ShakeDetector();

  SettingRepositoyImp();

  @override
  Future<void> loadSettings() async {
    await _settingStorage.loadSettings();
    _configureShake(_settingStorage.getSettings);
  }

  @override
  Future<void> saveSettings() async {
    await _settingStorage.saveSettings();
    _configureShake(_settingStorage.getSettings);
  }

  Settings get getSettings => _settingStorage.getSettings;

  void setSettings(Settings settings) {
    _settingStorage.setSettings(settings);
  }

  void _configureShake(Settings settings) {
    _shake.setSettingsShake(
        settings.getSensitivity, settings.getMinTime, settings.getShakeAmount);
  }
}
