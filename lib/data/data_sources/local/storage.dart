/*
/// 'Storage' maneja el almacenamiento y recuperación de datos en formato JSON utilizando 'SharedPreferences'.
///
/// Esta clase permite guardar, cargar y eliminar datos asociados a una clave específica.
/// Es útil para almacenar configuraciones, preferencias de usuario o cualquier tipo de datos estructurados en formato 'Map<String, dynamic>'.
///
/// Parámetros:
/// - '_key': Clave única utilizada para identificar los datos almacenados.
*/
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  late SharedPreferences _prefs;
  late final String _key;

  /// Constructor que recibe la clave única [_key] para almacenar y recuperar datos.
  Storage(this._key);

  /// Guarda un mapa de datos en 'SharedPreferences'.
  /// [data] - Mapa con la información que se almacenará localmente en formato JSON.
  Future<void> save(Map<String, dynamic> data) async {
    _prefs = await SharedPreferences.getInstance();
    String encode = json.encode(data);
    await _prefs.setString(_key, encode);
  }

  /// Carga los datos almacenados localmente.
  /// Retorna un 'Map<String, dynamic>' si existen datos asociados a [_key].
  /// En caso contrario, retorna 'null'.
  Future<Map<String, dynamic>?> load() async {
    _prefs = await SharedPreferences.getInstance();
    String? encode = _prefs.getString(_key);

    return encode != null ? json.decode(encode) : null;
  }

  /// Elimina los datos almacenados asociados a [_key] en 'SharedPreferences'.
  Future<void> clean() async {
    await _prefs.remove(_key);
  }
}
