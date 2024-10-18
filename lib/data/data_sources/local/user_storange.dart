import 'dart:convert';

import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorange {
  Future<void> store(User user) async {
    final prefs = await SharedPreferences.getInstance();

    final String userJson = jsonEncode(user.toJson());

    await prefs.setString('user', userJson);
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final String? userJson = prefs.getString('user');

    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    }

    return null;
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}
