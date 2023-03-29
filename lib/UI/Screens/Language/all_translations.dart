import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _storageKey = "MyApplication_";
const List<String> _supportedLanguages = ['en', 'ur'];
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class GlobalTranslations {
  Locale _locale;
  Map<dynamic, dynamic> _localizedValues;
  VoidCallback _onLocaleChangedCallback;

  Iterable<Locale> supportedLocales() =>
      _supportedLanguages.map<Locale>((lang) => new Locale(lang, 'ES'));

  String text(String key) {
    // Return the requested string
    return (_localizedValues == null || _localizedValues[key] == null)
        ? '** $key not found'
        : _localizedValues[key];
  }

  get currentLanguage => _locale == null ? 'es' : _locale.languageCode;
  get locale => _locale;

  Future<Null> init([String language]) async {
    if (_locale == null) {
      await setNewLanguage(language);
    }
    return null;
  }

  getPreferredLanguage() async {
    return _getApplicationSavedInformation('language');
  }

  setPreferredLanguage(String lang) async {
    return _setApplicationSavedInformation('language', lang);
  }

  Future<Null> setNewLanguage(
      [String newLanguage, bool saveInPrefs = false]) async {
    String language = newLanguage;
    if (language == null) {
      language = await getPreferredLanguage();
    }

    // Set the locale
    if (language == "") {
      language = "en";
    }
    _locale = Locale(language, "es");

    String jsonContent =
        await rootBundle.loadString("locale/i18n_${_locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);

    if (saveInPrefs) {
      await setPreferredLanguage(language);
    }

    if (_onLocaleChangedCallback != null) {
      _onLocaleChangedCallback();
    }

    return null;
  }

  ///
  /// Callback to be invoked when the user changes the language
  ///
  set onLocaleChangedCallback(VoidCallback callback) {
    _onLocaleChangedCallback = callback;
  }

  ///
  /// Application Preferences related
  ///
  /// ----------------------------------------------------------
  /// Generic routine to fetch an application preference
  /// ----------------------------------------------------------
  Future<String> _getApplicationSavedInformation(String name) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKey + name) ?? '';
  }

  /// ----------------------------------------------------------
  /// Generic routine to saves an application preference
  /// ----------------------------------------------------------
  Future<bool> _setApplicationSavedInformation(
      String name, String value) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKey + name, value);
  }

  ///
  /// Singleton Factory
  ///
  static final GlobalTranslations _translations =
      new GlobalTranslations._internal();
  factory GlobalTranslations() {
    return _translations;
  }
  GlobalTranslations._internal();
}

GlobalTranslations allTranslations = new GlobalTranslations();

class ChangeLanguage {
  SharedPreferences sharedPreferences;
  TextDirection textDirection;

  String lang;
  Map<dynamic, dynamic> _localizedValues;

  Future<Null> setNewLanguage(String language) async {
    String jsonContent =
        await rootBundle.loadString("locale/i18n_$language.json");
    _localizedValues = json.decode(jsonContent);
    print(_localizedValues['main_title']);
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("language", language);
    sharedPreferences.setString("labels", jsonContent);

    if (language == "es") {
      textDirection = TextDirection.rtl;
      sharedPreferences.setString("textDirection", "L");
    } else if (language == "en") {
      textDirection = TextDirection.ltr;
      sharedPreferences.setString("textDirection", "L");
    }

    return null;
  }

  String getLanguague() {
    final language = sharedPreferences.getString("language");
    return language;
  }

  dynamic loadandgetString(String key) async {
    final language = sharedPreferences.getString("language");
    String jsonContent =
        await rootBundle.loadString("locale/i18n_$language.json");
    sharedPreferences.setString("labels", jsonContent);
    _localizedValues = json.decode(jsonContent);

    if (language == "ur") {
      textDirection = TextDirection.rtl;
    } else if (language == "en") {
      textDirection = TextDirection.ltr;
    }

    return (_localizedValues == null || _localizedValues[key] == null)
        ? '** $key not found'
        : _localizedValues[key];
  }

  String text(String key) {
    return (_localizedValues == null || _localizedValues[key] == null)
        ? '** $key not found'
        : _localizedValues[key];
  }
}

ChangeLanguage changeLanguage = new ChangeLanguage();
