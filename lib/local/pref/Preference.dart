// import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static late Preference _prefHelper;
  static const USERNAME = "USERNAME";

  static const FIREBASE_TOKEN = "FIREBASE_TOKEN";
  static const USER_TOKEN = "USER_TOKEN";
  static const USER_EMAIL = "USER_EMAIL";
  static const PHONE = "phonenumber";
  static const NATIONALITY = "NATIONALITY";
  static const PROFILE_IMAGE = "PROFILE_IMAGE";
  static const GENDER = "GENDER";
  static const USER_ID = "USER_ID";
  static const FIRST_NAME = "FIRST_NAME";
  static const LAST_NAME = "LATS_NAME";
  static String IS_LOGIN = "isLogin";
  static const APP_VERSION = "APP_VERSION";

  static String APP_LANGUAGE = "APPLANGUAGE";
  static String CONTENT_LANGUAGE = "CONTEN_LANGUAGE";
  static String LANGUAGE = "LANGUAGE";
  static String DEFAULT_VIDEO_URL_CATEGORY = "DEFAULT_VIDEO_URL_CATEGORY";

  static String USER_TYPE = "userType";
  static String CATEGORY_DATA = "CATEGORY_DATA";
  static String USER_COINS = "USER_COINS";
  static String USER_DATA = "USER_DATA";
  static String DESIGNATION = 'designation';
  static String THEMECOLOR = 'THEMECOLOE';
  static String FONTFAMILY = 'FONTFAMILY';

  static getInstance() {
    // if (_prefHelper == null)
    _prefHelper = new Preference();
    return _prefHelper;
  }

  static SharedPreferences? _prefs;
  static Map<String, dynamic> _memoryPrefs = Map<String, dynamic>();
  // static late CacheStore store;

  static Future<SharedPreferences?> load() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static Future<bool?> clearPref() async {
    bool? clear = await _prefs?.clear();
    if (clear != null) {
      _memoryPrefs.clear();
    }
    return clear;
  }

  static void setString(String key, String value) {
    _prefs?.setString(key, value);
    _memoryPrefs[key] = value;
  }

  static void setListString(String key, List<String> value) {
    _prefs?.setStringList(key, value);
    _memoryPrefs[key] = value;
  }

  static void setInt(String key, int value) {
    _prefs?.setInt(key, value);
    _memoryPrefs[key] = value;
  }

  static void setDouble(String key, double value) {
    _prefs?.setDouble(key, value);
    _memoryPrefs[key] = value;
  }

  static void setBool(String key, bool value) {
    _prefs?.setBool(key, value);
    _memoryPrefs[key] = value;
  }

  static String? getString(String key) {
    String? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    if (val == null) val = _prefs?.getString(key);

    // val = def;

    _memoryPrefs[key] = val;
    return val;
  }

  static List<String>? getListString(String key, {List<String>? def}) {
    List<String>? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    if (val == null) {
      val = _prefs?.getStringList(key);
    }
    if (val == null) {
      val = def;
    }
    _memoryPrefs[key] = val;
    return val;
  }

  static bool? exists(String key, {String? def}) {
    return _prefs?.containsKey(key);
  }

  static int? getInt(String key, {int? def}) {
    int? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    if (val == null) {
      val = _prefs?.getInt(key);
    }
    if (val == null) {
      val = def;
    }
    _memoryPrefs[key] = val;
    return val;
  }

  static double? getDouble(String key, {double? def}) {
    double? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    if (val == null) {
      val = _prefs?.getDouble(key);
    }
    if (val == null) {
      val = def;
    }
    _memoryPrefs[key] = val;
    return val;
  }

  static bool? getBool(String key, {bool def = false}) {
    bool? val = def;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    if (_prefs == null) {
      return val;
    }
    val = _prefs?.getBool(key);
    if (val == null) val = def;
    _memoryPrefs[key] = val;
    return val;
  }
}
