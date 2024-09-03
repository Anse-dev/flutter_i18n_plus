import 'package:flutter/material.dart';
import 'i18n_plus.dart';

class I18nPlusProvider extends StatefulWidget {
  final Widget child;
  final List<Locale> supportedLocales;
  final Locale defaultLocale;
  final String translationsPath;

  const I18nPlusProvider({
    Key? key,
    required this.child,
    required this.supportedLocales,
    required this.defaultLocale,
    required this.translationsPath,
  }) : super(key: key);

  @override
  _I18nPlusProviderState createState() => _I18nPlusProviderState();

  static _I18nPlusProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<_I18nPlusProviderState>()!;
  }
}

class _I18nPlusProviderState extends State<I18nPlusProvider> {
  late Locale _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.defaultLocale;
    _initializeI18n();
  }

  Future<void> _initializeI18n() async {
    await I18nPlus().initialize(
      supportedLocales: widget.supportedLocales,
      defaultLocale: widget.defaultLocale,
      path: widget.translationsPath,
    );
    setState(() {
      _currentLocale = widget.defaultLocale;
    });
  }

  void setLocale(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
      I18nPlus().setLocale(newLocale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
