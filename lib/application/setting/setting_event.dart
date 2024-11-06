import 'package:alerta_uaz/domain/model/setting_model.dart';

abstract class SettingEvent {}

class LoadSetting extends SettingEvent {}

class SaveSetting extends SettingEvent {
  final Settings settings;

  SaveSetting({required this.settings});
}
