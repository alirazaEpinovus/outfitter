import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static Future savePreferenceString(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  static Future<String> getSharePreference(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(value);
  }

  static Future savePreferenceBoolean(String key, bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(key, value);
  }

  static Future<bool> getPreferenceBoolean(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool(key) == null) {
      return false;
    } else {
      return sharedPreferences.getBool(key);
    }
  }

  static int getdiscountpercentage(int price, int comparePrice) {
    int discount = (comparePrice - price).ceil();
    int singlepercentage = (comparePrice / 100).ceil();
    return (discount / singlepercentage).ceil();
  }
}
