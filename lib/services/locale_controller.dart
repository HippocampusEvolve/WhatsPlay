import 'package:flutter/widgets.dart';

import 'app_settings.dart';

/// Выбранный вручную язык приложения; null — как в системе.
/// MaterialApp слушает notifier и перестраивается при смене.
class LocaleController {
  LocaleController._();

  static final ValueNotifier<Locale?> locale = ValueNotifier(null);
  static late AppSettings _settings;

  static void init(AppSettings settings) {
    _settings = settings;
    final saved = settings.localeOverride;
    locale.value = saved == null ? null : Locale(saved);
  }

  static Future<void> set(String? languageCode) async {
    await _settings.setLocaleOverride(languageCode);
    locale.value = languageCode == null ? null : Locale(languageCode);
  }
}
