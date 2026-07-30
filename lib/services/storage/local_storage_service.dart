import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._();

  static Future<String?> getString(String key) async {
    final pref = await SharedPreferences.getInstance();
    final value = pref.getString(key);
    return value;
  }

  static Future<bool> setString(String key, value) async {
    final pref = await SharedPreferences.getInstance();
    final response = await pref.setString(key, value);
    return response;
  }
}
