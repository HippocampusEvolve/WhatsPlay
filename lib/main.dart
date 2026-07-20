import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/activity_repository.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/app_settings.dart';
import 'services/locale_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = await AppSettings.load();
  final repository = await ActivityRepository.load();
  LocaleController.init(settings);
  runApp(WhatsPlayApp(settings: settings, repository: repository));
}

class WhatsPlayApp extends StatelessWidget {
  const WhatsPlayApp({
    super.key,
    required this.settings,
    required this.repository,
  });

  final AppSettings settings;
  final ActivityRepository repository;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: LocaleController.locale,
      builder: (context, locale, _) => MaterialApp(
        title: 'WhatsPlay',
        debugShowCheckedModeBanner: false,
        locale: locale,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: const Color(0xFFFF8A3D)),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ru')],
        home: settings.hasChildren
            ? HomeScreen(settings: settings, repository: repository)
            : OnboardingScreen(settings: settings, repository: repository),
      ),
    );
  }
}
