import 'package:alerta_uaz/domain/model/setting_model.dart';

/// Define un contrato para el manejo de configuraciones de la aplicación.
/// Esta clase es una abstracción que debe ser implementada por clases concretas
/// para cargar y guardar la configuración del usuario.
abstract class SettingRepository {
  /// Carga la configuración del usuario almacenada en el sistema.
  /// [return] Un 'Future' que devuelve un objeto 'Settings' con los valores actuales.
  Future<Settings> loadSettings();

  /// Guarda la configuración del usuario en el sistema.
  /// [settings] Objeto 'Settings' que contiene la configuración actualizada del usuario.
  /// [return] Un 'Future' que representa el proceso de guardado.
  Future<void> saveSettings(Settings settings);
}
