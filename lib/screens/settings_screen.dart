import 'package:flutter/material.dart';

import '../data/activity_repository.dart';
import '../l10n/app_localizations.dart';
import '../services/app_settings.dart';
import '../services/locale_controller.dart';
import 'onboarding_screen.dart';

/// Настройки: язык приложения и анкета детей.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.settings,
    required this.repository,
  });

  final AppSettings settings;
  final ActivityRepository repository;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ValueListenableBuilder<Locale?>(
      valueListenable: LocaleController.locale,
      builder: (context, locale, _) {
        final current = locale?.languageCode ?? 'system';
        return Scaffold(
          appBar: AppBar(title: Text(l.settingsTitle)),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(l.language,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
              ),
              _LanguageTile(
                label: l.languageSystem,
                selected: current == 'system',
                onTap: () => LocaleController.set(null),
              ),
              _LanguageTile(
                label: 'Русский',
                selected: current == 'ru',
                onTap: () => LocaleController.set('ru'),
              ),
              _LanguageTile(
                label: 'English',
                selected: current == 'en',
                onTap: () => LocaleController.set('en'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.family_restroom),
                title: Text(l.editChildren),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OnboardingScreen(
                      settings: settings,
                      repository: repository,
                      editing: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
}
