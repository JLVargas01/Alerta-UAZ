import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  late SharedPreferences _prefs;
  late final String _key;

  Storage(this._key);

  /// Almacena los datos deseados en un documento localmente.
  Future<void> save(Map<String, dynamic> data) async {
    _prefs = await SharedPreferences.getInstance();
    String encode = json.encode(data);
    await _prefs.setString(_key, encode);
  }

  /// Cargamos los datos registrados localmente.
  /// Si existe algún dato extraido por [_key] entonces lo retornara.
  /// En caso contrario retornara null.
  Future<Map<String, dynamic>?> load() async {
    _prefs = await SharedPreferences.getInstance();
    String? encode = _prefs.getString(_key);

    return encode != null ? json.decode(encode) : null;
  }

  Future<void> clean() async {
    await _prefs.remove(_key);
  }
}
