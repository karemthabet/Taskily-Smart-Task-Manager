import 'package:shared_preferences/shared_preferences.dart';

class CashData {
  static SharedPreferences? sharedPreferences;

  static Future<void> cacheInitialization() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setData({required String key, dynamic value}) async {
    if (sharedPreferences == null) await cacheInitialization();
    
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is double) return await sharedPreferences!.setDouble(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    if (value is String) return await sharedPreferences!.setString(key, value);
    return false;
  }

  static dynamic getData({required String key}) {
    if (sharedPreferences == null) return null;
    return sharedPreferences!.get(key);
  }

  static Future<bool> deleteItem({required String key}) async {
    if (sharedPreferences == null) await cacheInitialization();
    return await sharedPreferences!.remove(key);
  }

  static Future<void> clear() async {
    if (sharedPreferences == null) await cacheInitialization();
    await sharedPreferences!.clear();
  }
}
