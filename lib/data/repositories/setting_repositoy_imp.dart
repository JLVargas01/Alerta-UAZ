import 'package:alerta_uaz/core/device/shake_detector.dart';
import 'package:alerta_uaz/data/data_sources/local/setting_storage.dart';
import 'package:alerta_uaz/domain/model/setting_model.dart';
import 'package:alerta_uaz/domain/repositories/setting_repository.dart';

class SettingRepositoyImp implements SettingRepository {
  final SettingStorage _settingStorage = SettingStorage();
  final _shake = ShakeDetector();

  SettingRepositoyImp();

  @override
  Future<Settings> loadSettings() async {
    final settingsShake = await _settingStorage.loadSettings();
    _setSettingsShake(settingsShake);
    return settingsShake;
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    await _settingStorage.saveSettings(settings);
    _setSettingsShake(settings);
  }

  void _setSettingsShake(Settings settings) {
    _shake.setSettingsShake(
        settings.getSensitivity, settings.getMinTime, settings.getShakeAmount);
  }
}
