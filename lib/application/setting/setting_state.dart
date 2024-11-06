import 'package:alerta_uaz/domain/model/setting_model.dart';

abstract class SettingState {}

class Settingloading extends SettingState {}

class SettingLoaded extends SettingState {
  final Settings settings;

  SettingLoaded({required this.settings});
}

class SettingSaved extends SettingState {
  final Settings settings;

  SettingSaved({required this.settings});
}

class SettingError extends SettingState {
  final String message;

  SettingError({required this.message});
}
