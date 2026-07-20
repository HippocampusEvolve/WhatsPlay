import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/locale_controller.dart';

/// Кнопка выбора языка: системный / русский / английский.
class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final current = LocaleController.locale.value?.languageCode;
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      tooltip: l.language,
      initialValue: current ?? 'system',
      onSelected: (v) => LocaleController.set(v == 'system' ? null : v),
      itemBuilder: (context) => [
        PopupMenuItem(value: 'system', child: Text(l.languageSystem)),
        const PopupMenuItem(value: 'ru', child: Text('Русский')),
        const PopupMenuItem(value: 'en', child: Text('English')),
      ],
    );
  }
}
