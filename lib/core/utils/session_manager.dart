import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> setValue(String key, String value) async {
    final prefs = await _prefs;
    return prefs.setString(key, value);
  }

  Future<String?> getValue(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<bool> clearValue(String key) async {
    final prefs = await _prefs;
    final result = await prefs.remove(key);
    await prefs.reload();
    return result;
  }

  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
    await prefs.reload();
  }
}
