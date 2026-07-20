import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

/// Места, где можно играть. Ключи совпадают с полем locations в базе игр.
const List<({String key, String emoji})> kLocations = [
  (key: 'home', emoji: '🏠'),
  (key: 'yard', emoji: '🏘️'),
  (key: 'city', emoji: '🏙️'),
  (key: 'village', emoji: '🏡'),
  (key: 'nature', emoji: '🌲'),
];

String locationLabel(BuildContext context, String key) {
  final l = AppLocalizations.of(context)!;
  switch (key) {
    case 'home':
      return l.locationHome;
    case 'yard':
      return l.locationYard;
    case 'city':
      return l.locationCity;
    case 'village':
      return l.locationVillage;
    case 'nature':
      return l.locationNature;
    default:
      return key;
  }
}

/// Язык контента базы: русский для русской локали, иначе английский.
String contentLang(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'ru' ? 'ru' : 'en';
