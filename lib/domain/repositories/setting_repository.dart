import 'package:alerta_uaz/domain/model/setting_model.dart';

abstract class SettingRepository {
  Future<Settings> loadSettings();
  Future<void> saveSettings(Settings settings);
}
