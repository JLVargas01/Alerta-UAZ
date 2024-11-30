import 'dart:convert';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const String _userKey = 'user';

  static Future<void> store(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final String userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  // Obtiene el usuario completo
  static Future<User?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(_userKey);
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      User user = User();
      user.fromJson(userMap);
      ;
      return user;
    }
    return null;
  }

  // Obtiene el id de la lista
  static Future<String?> getIdListContaData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(_userKey);
    if (userJson != null) {
      final Map<String, dynamic> userMap = json.decode(userJson);

      return userMap['id_contact_list'];
    }
    return null;
  }

  // Borra el usuario completo
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
