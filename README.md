# I18nPlus

I18nPlus est un package de internationalisation avancé pour les applications Flutter. Il offre une solution simple et flexible pour gérer les traductions, le formatage des dates et des devises, ainsi que la pluralisation dans vos applications Flutter.

## Fonctionnalités

- Gestion facile des traductions avec support pour les clés imbriquées
- Pluralisation
- Formatage des dates
- Formatage des devises
- Changement dynamique de langue
- Support pour les arguments dans les traductions

## Installation

Ajoutez I18nPlus à votre fichier `pubspec.yaml` :

```yaml
dependencies:
  flutter_i18n_plus: ^1.0.0
```

Ensuite, exécutez :

```
flutter pub get
```

## Configuration

1. Créez un dossier `assets/translations/` dans votre projet.
2. Ajoutez vos fichiers de traduction JSON dans ce dossier (par exemple, `en.json`, `fr.json`).
3. Mettez à jour votre `pubspec.yaml` pour inclure les assets :

```yaml
flutter:
  assets:
    - assets/translations/
```

## Utilisation

### Initialisation

Enveloppez votre `MaterialApp` (ou `CupertinoApp`) avec `I18nPlusProvider` :

```dart
void main() {
  runApp(
    I18nPlusProvider(
      supportedLocales: [Locale('en', 'US'), Locale('fr', 'FR')],
      defaultLocale: Locale('en', 'US'),
      translationsPath: 'assets/translations',
      child: MyApp(),
    ),
  );
}
```

### Traductions simples

Utilisez l'extension `t` sur `BuildContext` pour accéder aux traductions :

```dart
Text(context.t('greeting'))
```

### Traductions avec arguments

```dart
Text(context.t('welcome', args: {'name': 'John'}))
```

### Pluralisation

Utilisez l'extension `p` sur `BuildContext` pour la pluralisation :

```dart
Text(context.p('items', itemCount, args: {'count': itemCount.toString()}))
```

### Formatage de date

```dart
Text(I18nPlus().formatDate(DateTime.now()))
```

### Formatage de devise

```dart
Text(I18nPlus().formatCurrency(1234.56))
```

### Changement de langue

```dart
ElevatedButton(
  onPressed: () {
    final newLocale = I18nPlus().currentLocale.languageCode == 'en'
        ? Locale('fr', 'FR')
        : Locale('en', 'US');
    I18nPlusProvider.of(context).setLocale(newLocale);
  },
  child: Text('Changer de langue'),
)
```

## Exemple de fichier de traduction

`en.json`:

```json
{
  "greeting": "Hello",
  "welcome": "Welcome, {name}!",
  "items": {
    "one": "{count} item",
    "other": "{count} items"
  }
}
```

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou à soumettre une pull request sur GitHub.

## Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.
