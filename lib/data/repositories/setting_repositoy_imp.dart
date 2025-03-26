import 'package:alerta_uaz/core/device/shake_detector.dart';
import 'package:alerta_uaz/data/data_sources/local/setting_storage.dart';
import 'package:alerta_uaz/domain/model/setting_model.dart';
import 'package:alerta_uaz/domain/repositories/setting_repository.dart';

/// Implementación del repositorio de configuración.
/// Gestiona el almacenamiento y recuperación de configuraciones de la aplicación.
class SettingRepositoyImp implements SettingRepository {
  final SettingStorage _settingStorage = SettingStorage();
  final _shake = ShakeDetector();

  SettingRepositoyImp();

  /// Carga la configuración almacenada y la aplica al detector de sacudidas.
  /// [settingsShake] Configuración actual de la aplicación.
  @override
  Future<Settings> loadSettings() async {
    final settingsShake = await _settingStorage.loadSettings();
    _setSettingsShake(settingsShake);
    return settingsShake;
  }

  /// Guarda la configuración proporcionada y la aplica al detector de sacudidas.
  /// [settings] Configuración a guardar.
  @override
  Future<void> saveSettings(Settings settings) async {
    await _settingStorage.saveSettings(settings);
    _setSettingsShake(settings);
  }

  /// Aplica la configuración al detector de sacudidas.
  /// [settings] Configuración que se aplicará al detector.
  void _setSettingsShake(Settings settings) {
    _shake.setSettingsShake(
        settings.getSensitivity, settings.getMinTime, settings.getShakeAmount);
  }
}
