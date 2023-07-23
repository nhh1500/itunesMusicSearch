import 'package:shared_preferences/shared_preferences.dart';

///SharedPreference class
class SharedPrefs {
  static late SharedPreferences prefs;

  /// must init SharedPreference before using
  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  ///get value from SharedPreference
  ///only support type String, bool, int, double, and List<String>
  static Object? getValue(String key, Object type) {
    switch (type) {
      case String:
        return prefs.getString(key);
      case bool:
        return prefs.getBool(key);
      case int:
        return prefs.getInt(key);
      case double:
        return prefs.getDouble(key);
      case List<String>:
        return prefs.getStringList(key);
      default:
        return null;
    }
  }

  ///update Value from SharedPreference
  ///only support type String, bool, int, double, and List<String>
  static setValue(String key, Object value) async {
    switch (value.runtimeType) {
      case String:
        await prefs.setString(key, value as String);
        break;
      case bool:
        await prefs.setBool(key, value as bool);
        break;
      case int:
        await prefs.setInt(key, value as int);
        break;
      case double:
        await prefs.setDouble(key, value as double);
        break;
      case List<String>:
        await prefs.setStringList(key, value as List<String>);
        break;
      default:
        break;
    }
  }

  /// Remove value from SharedPreference
  static Future<bool> removeValue(String key) async {
    final success = await prefs.remove(key);
    return success;
  }
}
