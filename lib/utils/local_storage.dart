import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StorableDataType {
  String,
  BOOL,
  DOUBLE,
  INT,
  STRINGLIST,
}

class AppLocalKeys {
  // API Endpoint
  static const String API_URL = 'api_url';

  // API Suffix
  static const String API_SUFFIX = 'api_suffix';

  // token
  static const String TOKEN = 'token';

  static const String SME_PHONE = 'sms_phone';

  // login remember
  static const String IS_REMEMBER = 'isremember';

  // username
  static const String USERNAME = 'username';

  // userid
  static const String USERID = 'userid';

  //theme
  static const String THEME = 'theme';

  // Welcome Page
  static const String WELCOME_PASS = 'welcome_pass';
}

Future<void> storeDataToLocal(
    {required String key,
    required dynamic value,
    required StorableDataType type}) async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  switch (type) {
    case StorableDataType.String:
      bool result = await _sharedPreferences.setString(key, value);
      break;
    case StorableDataType.BOOL:
      bool result = await _sharedPreferences.setBool(key, value);
      break;
    case StorableDataType.INT:
      bool result = await _sharedPreferences.setInt(key, value);
      break;
    case StorableDataType.DOUBLE:
      bool result = await _sharedPreferences.setDouble(key, value);
      break;
    case StorableDataType.STRINGLIST:
      bool result = await _sharedPreferences.setStringList(key, value);
      break;
    default:
  }
}

Future<dynamic> getDataInLocal(
    {required String key, required StorableDataType type}) async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  switch (type) {
    case StorableDataType.String:
      return _sharedPreferences.getString(key);
      break;
    case StorableDataType.BOOL:
      return _sharedPreferences.getBool(key);
      break;
    case StorableDataType.INT:
      return _sharedPreferences.getInt(key);
      break;
    case StorableDataType.DOUBLE:
      return _sharedPreferences.getDouble(key);
      break;
    case StorableDataType.STRINGLIST:
      return _sharedPreferences.getStringList(key);
      break;
    default:
      return null;
  }
}

Future<dynamic> removeDataInLocal(String key) async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  _sharedPreferences.remove(key);
}
