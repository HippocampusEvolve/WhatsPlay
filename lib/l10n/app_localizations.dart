import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'WhatsPlay'**
  String get appTitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Who is going to play?'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your kids\' ages so we can suggest games that fit.'**
  String get onboardingSubtitle;

  /// No description provided for @addChild.
  ///
  /// In en, this message translates to:
  /// **'Add a child'**
  String get addChild;

  /// No description provided for @childAge.
  ///
  /// In en, this message translates to:
  /// **'{age, plural, one {{age} year old} other {{age} years old}}'**
  String childAge(int age);

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go!'**
  String get continueButton;

  /// No description provided for @whereAreYou.
  ///
  /// In en, this message translates to:
  /// **'Where are you now?'**
  String get whereAreYou;

  /// No description provided for @locationHome.
  ///
  /// In en, this message translates to:
  /// **'At home'**
  String get locationHome;

  /// No description provided for @locationYard.
  ///
  /// In en, this message translates to:
  /// **'In the yard'**
  String get locationYard;

  /// No description provided for @locationCity.
  ///
  /// In en, this message translates to:
  /// **'In the city'**
  String get locationCity;

  /// No description provided for @locationVillage.
  ///
  /// In en, this message translates to:
  /// **'In the village'**
  String get locationVillage;

  /// No description provided for @locationNature.
  ///
  /// In en, this message translates to:
  /// **'Out in nature'**
  String get locationNature;

  /// No description provided for @whatToPlay.
  ///
  /// In en, this message translates to:
  /// **'What shall we play?'**
  String get whatToPlay;

  /// No description provided for @anotherIdea.
  ///
  /// In en, this message translates to:
  /// **'Another idea'**
  String get anotherIdea;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get addToFavorites;

  /// No description provided for @savedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedToFavorites;

  /// No description provided for @originLabel.
  ///
  /// In en, this message translates to:
  /// **'Where this game comes from'**
  String get originLabel;

  /// No description provided for @propsLabel.
  ///
  /// In en, this message translates to:
  /// **'You will need'**
  String get propsLabel;

  /// No description provided for @propsNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing at all'**
  String get propsNothing;

  /// No description provided for @agesLabel.
  ///
  /// In en, this message translates to:
  /// **'Ages'**
  String get agesLabel;

  /// No description provided for @agesValue.
  ///
  /// In en, this message translates to:
  /// **'{min}–{max}'**
  String agesValue(int min, int max);

  /// No description provided for @playersLabel.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get playersLabel;

  /// No description provided for @playersValue.
  ///
  /// In en, this message translates to:
  /// **'{min, plural, other {{min}+}}'**
  String playersValue(int min);

  /// No description provided for @safetyLabel.
  ///
  /// In en, this message translates to:
  /// **'Stay safe'**
  String get safetyLabel;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved games'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet. Tap “Save” on a game you like!'**
  String get favoritesEmpty;

  /// No description provided for @editChildren.
  ///
  /// In en, this message translates to:
  /// **'Edit kids'**
  String get editChildren;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Same as device'**
  String get languageSystem;

  /// No description provided for @noMatch.
  ///
  /// In en, this message translates to:
  /// **'No game matched these filters. Try another place!'**
  String get noMatch;

  /// No description provided for @kidsLine.
  ///
  /// In en, this message translates to:
  /// **'Playing: {ages}'**
  String kidsLine(String ages);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
