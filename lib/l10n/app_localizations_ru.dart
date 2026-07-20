// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'WhatsPlay';

  @override
  String get onboardingTitle => 'Кто будет играть?';

  @override
  String get onboardingSubtitle =>
      'Добавь возраст детей — будем подбирать игры по возрасту.';

  @override
  String get addChild => 'Добавить ребёнка';

  @override
  String childAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age лет',
      few: '$age года',
      one: '$age год',
    );
    return '$_temp0';
  }

  @override
  String get continueButton => 'Поехали!';

  @override
  String get whereAreYou => 'Где вы сейчас?';

  @override
  String get locationHome => 'Дома';

  @override
  String get locationYard => 'Во дворе';

  @override
  String get locationCity => 'В городе';

  @override
  String get locationVillage => 'В деревне';

  @override
  String get locationNature => 'На природе';

  @override
  String get whatToPlay => 'Чем заняться?';

  @override
  String get anotherIdea => 'Ещё вариант';

  @override
  String get addToFavorites => 'Сохранить';

  @override
  String get savedToFavorites => 'Сохранено';

  @override
  String get originLabel => 'Откуда эта игра';

  @override
  String get propsLabel => 'Что понадобится';

  @override
  String get propsNothing => 'Ничего не нужно';

  @override
  String get agesLabel => 'Возраст';

  @override
  String agesValue(int min, int max) {
    return '$min–$max';
  }

  @override
  String get playersLabel => 'Игроки';

  @override
  String playersValue(int min) {
    String _temp0 = intl.Intl.pluralLogic(
      min,
      locale: localeName,
      other: 'от $min',
    );
    return '$_temp0';
  }

  @override
  String get safetyLabel => 'Осторожно';

  @override
  String get favoritesTitle => 'Сохранённые игры';

  @override
  String get favoritesEmpty =>
      'Пока пусто. Нажми «Сохранить» на игре, которая понравилась!';

  @override
  String get editChildren => 'Изменить детей';

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Как в системе';

  @override
  String get noMatch =>
      'Под эти условия игра не нашлась. Попробуй другое место!';

  @override
  String kidsLine(String ages) {
    return 'Играют: $ages';
  }
}
