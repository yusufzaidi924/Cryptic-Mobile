import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/translations/localization_service.dart';

enum PrefType {
  BOOL,
  STRING,
  INT,
  DOUBLE,
  STRINGLIST,
}

class MySharedPref {
  // prevent making instance
  MySharedPref._();

  // get storage
  static late SharedPreferences _sharedPreferences;

  // STORING KEYS
  static const String FCM_TOKEN = 'fcm_token';
  static const String CURRENT_LOCAL = 'current_local';
  static const String LIGHT_THEME = 'is_theme_light';
  static const String TOKEN = 'auth_token';
  static const String IS_LOGIN = 'isLogin';
  static const String LOGIN_METHOD = 'loginMethod';
  static const String LOGIN_NAME = 'loginName';
  static const String LOGIN_EMAIL = 'loginEmail';
  static const String ACCEPTED_TERMS_OF_USE = "accepted_terms_of_use";
  static const String FIRST_LOGIN = 'first_login';

  /// init get storage services
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  /// set theme current type as light theme
  static Future<void> setThemeIsLight(bool lightTheme) =>
      _sharedPreferences.setBool(LIGHT_THEME, lightTheme);

  /// get if the current theme type is light
  static bool getThemeIsLight() =>
      _sharedPreferences.getBool(LIGHT_THEME) ??
      true; // todo set the default theme (true for light, false for dark)

  /// save current locale
  static Future<void> setCurrentLanguage(String languageCode) =>
      _sharedPreferences.setString(CURRENT_LOCAL, languageCode);

  /// get current locale
  static Locale getCurrentLocal() {
    String? langCode = _sharedPreferences.getString(CURRENT_LOCAL);
    // default language is english
    if (langCode == null) {
      return LocalizationService.defaultLanguage;
    }
    return LocalizationService.supportedLanguages[langCode]!;
  }

  /// save generated fcm token
  static Future<void> setFcmToken(String token) =>
      _sharedPreferences.setString(FCM_TOKEN, token);

  /// get generated fcm token
  static String? getFcmToken() => _sharedPreferences.getString(FCM_TOKEN);

  /// save  token
  static Future<void> setAuthToken(String token) =>
      _sharedPreferences.setString(TOKEN, token);

  /// terms
  static Future<void> setTerms(bool value) =>
      _sharedPreferences.setBool(ACCEPTED_TERMS_OF_USE, value);

  /// set first login
  static Future<void> setFirstLogin(bool value) =>
      _sharedPreferences.setBool(FIRST_LOGIN, value);

  /// check first or not
  static bool? checkFirstLogin() => _sharedPreferences.getBool(FIRST_LOGIN);

  // /// check agree terms
  // static bool? checkAgreeTerms() => _sharedPreferences.getBool(FIRST_LOGIN);

  /// get  token
  static String? getAuthToken() => _sharedPreferences.getString(TOKEN);

  static Future<void> saveData(
      {required value, required String key, required PrefType type}) async {
    switch (type) {
      case PrefType.BOOL:
        _sharedPreferences.setBool(key, value);
        break;

      case PrefType.STRING:
        _sharedPreferences.setString(key, value);
        break;

      case PrefType.INT:
        _sharedPreferences.setInt(key, value);
        break;

      case PrefType.DOUBLE:
        _sharedPreferences.setDouble(key, value);
        break;

      case PrefType.STRINGLIST:
        _sharedPreferences.setStringList(key, value);
        break;
      default:
    }
  }

  static Future getData({required String key, required PrefType type}) async {
    switch (type) {
      case PrefType.BOOL:
        return _sharedPreferences.getBool(key);

      case PrefType.STRING:
        return _sharedPreferences.getString(key);

      case PrefType.INT:
        return _sharedPreferences.getInt(key);

      case PrefType.DOUBLE:
        return _sharedPreferences.getDouble(key);

      case PrefType.STRINGLIST:
        return _sharedPreferences.getStringList(key);

      default:
    }
  }

  /// clear all data from shared pref
  static Future<void> clear() async => await _sharedPreferences.clear();
}
