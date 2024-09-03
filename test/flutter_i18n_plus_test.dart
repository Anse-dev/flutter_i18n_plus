import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_i18n_plus/flutter_i18n_plus.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late I18nPlus i18n;

  setUpAll(() async {
    await initializeDateFormatting();

    // Simuler les fichiers de traduction
    final Map<String, String> fakeAssets = {
      'assets/translations/en.json': json.encode({
        "greeting": "Hello",
        "greeting_with_name": "Hello, {name}!",
        "menu": {
          "file": {"open": "Open file"}
        },
        "items": {
          "one": "You have {count} {type}",
          "other": "You have {count} {type}s"
        }
      }),
      'assets/translations/fr.json': json.encode({
        "greeting": "Bonjour",
        "greeting_with_name": "Bonjour, {name} !",
        "menu": {
          "file": {"open": "Ouvrir le fichier"}
        },
        "items": {
          "one": "Vous avez {count} {type}",
          "other": "Vous avez {count} {type}s"
        }
      }),
    };

    // Remplacer la méthode load de rootBundle
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      final String key = utf8.decode(message!.buffer
          .asUint8List(message.offsetInBytes, message.lengthInBytes));
      if (fakeAssets.containsKey(key)) {
        return ByteData.view(
            Uint8List.fromList(utf8.encode(fakeAssets[key]!)).buffer);
      }
      return null;
    });

    // Initialiser I18nPlus
    i18n = I18nPlus();
    await i18n.initialize(
      supportedLocales: [const Locale('en', 'US'), const Locale('fr', 'FR')],
      defaultLocale: const Locale('en', 'US'),
      path: 'assets/translations',
    );
  });

  group('I18nPlus - Basic Functionality', () {
    test('initialize sets correct default locale', () {
      expect(i18n.currentLocale, const Locale('en', 'US'));
    });

    test('setLocale changes current locale', () {
      i18n.setLocale(const Locale('fr', 'FR'));
      expect(i18n.currentLocale, const Locale('fr', 'FR'));
    });

    test('setLocale ignores unsupported locale', () {
      i18n.setLocale(const Locale('es', 'ES'));
      expect(i18n.currentLocale, const Locale('fr', 'FR'));
    });
  });

  group('I18nPlus - Translations', () {
    test('translate returns correct translation', () {
      i18n.setLocale(const Locale('en', 'US'));
      expect(i18n.translate('greeting'), 'Hello');
      expect(i18n.translate('greeting_with_name', args: {'name': 'World'}),
          'Hello, World!');
    });

    test('translate handles nested keys', () {
      expect(i18n.translate('menu.file.open'), 'Open file');
    });

    test('translate returns key if translation not found', () {
      expect(i18n.translate('nonexistent.key'), 'nonexistent.key');
    });

    test('translate works with different locales', () {
      i18n.setLocale(const Locale('en', 'US'));
      expect(i18n.translate('greeting'), 'Hello');
      i18n.setLocale(const Locale('fr', 'FR'));
      expect(i18n.translate('greeting'), 'Bonjour');
    });
  });

  group('I18nPlus - Plurals', () {
    test('plural returns correct form for English', () {
      i18n.setLocale(const Locale('en', 'US'));
      expect(i18n.plural('items', 0, args: {'type': 'apple'}),
          'You have 0 apples');
      expect(
          i18n.plural('items', 1, args: {'type': 'apple'}), 'You have 1 apple');
      expect(i18n.plural('items', 2, args: {'type': 'apple'}),
          'You have 2 apples');
    });

    test('plural returns correct form for French', () {
      i18n.setLocale(const Locale('fr', 'FR'));
      expect(i18n.plural('items', 0, args: {'type': 'pomme'}),
          'Vous avez 0 pomme');
      expect(i18n.plural('items', 1, args: {'type': 'pomme'}),
          'Vous avez 1 pomme');
      expect(i18n.plural('items', 2, args: {'type': 'pomme'}),
          'Vous avez 2 pommes');
    });
  });

  group('I18nPlus - Date Formatting', () {
    test('formatDate returns correct format for English', () {
      i18n.setLocale(const Locale('en', 'US'));
      final date = DateTime(2023, 5, 15);
      expect(i18n.formatDate(date), '2023-05-15');
      expect(i18n.formatDate(date, format: 'MM/dd/yyyy'), '05/15/2023');
    });
  });

  group('I18nPlus - Currency Formatting', () {
    test('formatCurrency returns correct format for English', () {
      i18n.setLocale(const Locale('en', 'US'));
      expect(i18n.formatCurrency(1234.56), '1,234.56');
      expect(i18n.formatCurrency(1234.56, symbol: '\$'), '\$1,234.56');
    });
  });
}
