import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class I18nPlus {
  static final I18nPlus _instance = I18nPlus._internal();
  factory I18nPlus() => _instance;
  I18nPlus._internal();

  Map<String, Map<String, dynamic>> _translations = {};
  Locale _currentLocale = const Locale('en', 'US');
  List<Locale> _supportedLocales = [];

  Locale get currentLocale => _currentLocale;

  Future<void> initialize({
    required List<Locale> supportedLocales,
    Locale? defaultLocale,
    required String path,
  }) async {
    _supportedLocales = supportedLocales;
    _currentLocale = defaultLocale ?? supportedLocales.first;
    // Initialiser les données de formatage de date pour toutes les locales supportées
    for (var locale in supportedLocales) {
      await initializeDateFormatting(locale.toString(), null);
    }

    await loadTranslationsFromAssets(path);
  }

  void setLocale(Locale locale) async {
    if (_supportedLocales.contains(locale)) {
      _currentLocale = locale;
      await initializeDateFormatting(locale.toString(), null);
    } else {
      print('Locale non prise en charge: $locale');
    }
  }

  String translate(String key, {Map<String, dynamic>? args}) {
    final keys = key.split('.');
    dynamic translation = _translations[_currentLocale.languageCode];

    for (final k in keys) {
      if (translation is! Map<String, dynamic>) return key;
      translation = translation[k];
      if (translation == null) return key;
    }

    if (translation is! String) return key;

    if (args != null) {
      args.forEach((argKey, argValue) {
        translation = translation.replaceAll('{$argKey}', argValue.toString());
      });
    }

    return translation;
  }

  Future<void> loadTranslationsFromAssets(String path) async {
    for (final locale in _supportedLocales) {
      final jsonString =
          await rootBundle.loadString('$path/${locale.languageCode}.json');
      _translations[locale.languageCode] = json.decode(jsonString);
    }
  }

  String plural(String key, int count, {Map<String, dynamic>? args}) {
    final pluralKey = '$key.${_getPluralSuffix(count)}';
    return translate(pluralKey, args: {...?args, 'count': count});
  }

  String _getPluralSuffix(int count) {
    switch (_currentLocale.languageCode) {
      case 'en':
        return count == 1 ? 'one' : 'other';
      case 'fr':
        return count <= 1 ? 'one' : 'other';
      default:
        return 'other';
    }
  }

  String formatDate(DateTime date, {String? format}) {
    final localeString = _currentLocale.toString();
    final formatter = DateFormat(format ?? 'yyyy-MM-dd', localeString);
    return formatter.format(date);
  }

  String formatCurrency(double amount, {String? symbol}) {
    final formatter = NumberFormat.currency(
      locale: _currentLocale.toString(),
      symbol: symbol ?? '',
    );
    return formatter.format(amount);
  }
}

extension I18nPlusExtension on BuildContext {
  String t(String key, {Map<String, dynamic>? args}) {
    return I18nPlus().translate(key, args: args);
  }

  String p(String key, int count, {Map<String, dynamic>? args}) {
    return I18nPlus().plural(key, count, args: args);
  }
}
