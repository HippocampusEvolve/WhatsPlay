// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WhatsPlay';

  @override
  String get onboardingTitle => 'Who is going to play?';

  @override
  String get onboardingSubtitle =>
      'Add your kids\' ages so we can suggest games that fit.';

  @override
  String get addChild => 'Add a child';

  @override
  String childAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age years old',
      one: '$age year old',
    );
    return '$_temp0';
  }

  @override
  String get continueButton => 'Let\'s go!';

  @override
  String get whereAreYou => 'Where are you now?';

  @override
  String get locationHome => 'At home';

  @override
  String get locationYard => 'In the yard';

  @override
  String get locationCity => 'In the city';

  @override
  String get locationVillage => 'In the village';

  @override
  String get locationNature => 'Out in nature';

  @override
  String get whatToPlay => 'What shall we play?';

  @override
  String get forEachChild => 'One for each';

  @override
  String get shuffleAll => 'Shuffle all';

  @override
  String get energyActive => 'active';

  @override
  String get energyCalm => 'calm';

  @override
  String get anotherIdea => 'Another idea';

  @override
  String get addToFavorites => 'Save';

  @override
  String get savedToFavorites => 'Saved';

  @override
  String get originLabel => 'Where this game comes from';

  @override
  String get propsLabel => 'You will need';

  @override
  String get propsNothing => 'Nothing at all';

  @override
  String get agesLabel => 'Ages';

  @override
  String agesValue(int min, int max) {
    return '$min–$max';
  }

  @override
  String get playersLabel => 'Players';

  @override
  String playersValue(int min) {
    String _temp0 = intl.Intl.pluralLogic(
      min,
      locale: localeName,
      other: '$min+',
    );
    return '$_temp0';
  }

  @override
  String get safetyLabel => 'Stay safe';

  @override
  String get variantsLabel => 'Around the world, through the ages';

  @override
  String get favoritesTitle => 'Saved games';

  @override
  String get favoritesEmpty =>
      'Nothing saved yet. Tap “Save” on a game you like!';

  @override
  String get editChildren => 'Edit kids';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Same as device';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get noMatch => 'No game matched these filters. Try another place!';

  @override
  String kidsLine(String ages) {
    return 'Playing: $ages';
  }
}
