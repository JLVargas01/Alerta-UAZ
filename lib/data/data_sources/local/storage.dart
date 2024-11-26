import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  late final SharedPreferences _prefs;
  late final String _key;

  Storage(this._key) {
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Almacena los datos deseados en un documento localmente.
  Future<void> save(Map<String, dynamic> data) async {
    String encode = jsonEncode(data);
    await _prefs.setString(_key, encode);
  }

  /// Cargamos los datos registrados localmente.
  /// Si existe algún dato extraido por [_key] entonces lo retornara.
  /// En caso contrario retornara null.
  Future<Map<String, dynamic>?> load() async {
    String? encode = _prefs.getString(_key);

    return encode != null ? jsonDecode(encode) : null;
  }

  Future<void> clean() async {
    await _prefs.remove(_key);
  }
}
