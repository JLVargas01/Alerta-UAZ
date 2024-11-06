import 'package:alerta_uaz/application/setting/setting_event.dart';
import 'package:alerta_uaz/application/setting/setting_state.dart';
import 'package:alerta_uaz/data/repositories/setting_repositoy_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final _settingRepositoyImp = SettingRepositoyImp();

  SettingBloc() : super(Settingloading()) {
    on<LoadSetting>(
      (event, emit) async {
        try {
          emit(Settingloading());
          await Future.delayed(const Duration(milliseconds: 500));
          await _settingRepositoyImp.loadSettings();
          final settings = _settingRepositoyImp.getSettings;
          emit(SettingLoaded(settings: settings));
        } catch (e) {
          emit(SettingError(
              message: 'Error al cargar la configuración: ${e.toString()}'));
        }
      },
    );

    on<SaveSetting>(
      (event, emit) async {
        try {
          emit(Settingloading());
          await Future.delayed(const Duration(milliseconds: 500));
          final settings = event.settings;
          _settingRepositoyImp.setSettings(settings);
          await _settingRepositoyImp.saveSettings();
          emit(SettingSaved(settings: settings));
        } catch (error) {
          emit(SettingError(
              message:
                  'Error al guardar la configuración: ${error.toString()}'));
        }
      },
    );
  }
}
