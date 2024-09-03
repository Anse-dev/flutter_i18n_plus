import 'package:flutter/material.dart';
import 'package:flutter_i18n_plus/flutter_i18n_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return I18nPlusProvider(
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      defaultLocale: const Locale('en', 'US'),
      translationsPath: 'assets/translations',
      child: MaterialApp(
        title: 'I18nPlus Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('app.title')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(context.t('greeting', args: {'name': 'Flutter'})),
            const SizedBox(height: 20),
            Text(
              context
                  .p('counter', _counter, args: {'count': _counter.toString()}),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(context.t('current_date',
                args: {'date': I18nPlus().formatDate(DateTime.now())})),
            const SizedBox(height: 20),
            Text(context.t('account_balance',
                args: {'balance': I18nPlus().formatCurrency(1234.56)})),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                final newLocale = I18nPlus().currentLocale.languageCode == 'en'
                    ? const Locale('fr', 'FR')
                    : const Locale('en', 'US');
                I18nPlusProvider.of(context).setLocale(newLocale);
                setState(() {}); // Forcer la reconstruction du widget
              },
              child: Text(
                  '${context.t('change_language')} (${I18nPlus().currentLocale.languageCode})'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: context.t('increment'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
