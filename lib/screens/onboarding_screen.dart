import 'package:flutter/material.dart';

import '../data/activity_repository.dart';
import '../l10n/app_localizations.dart';
import '../services/app_settings.dart';
import 'home_screen.dart';
import 'language_button.dart';

/// Анкета: возраст детей. Показывается при первом запуске и при редактировании.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.settings,
    required this.repository,
    this.editing = false,
  });

  final AppSettings settings;
  final ActivityRepository repository;
  final bool editing;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final List<int> _ages = List.of(widget.settings.childAges);

  Future<void> _addChild() async {
    final l = AppLocalizations.of(context)!;
    final age = await showModalBottomSheet<int>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.addChild, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var a = 1; a <= 16; a++)
                    ActionChip(
                      label: Text('$a'),
                      onPressed: () => Navigator.pop(context, a),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (age != null) {
      setState(() => _ages.add(age));
    }
  }

  Future<void> _save() async {
    await widget.settings.setChildAges(_ages);
    if (!mounted) return;
    if (widget.editing) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            settings: widget.settings,
            repository: widget.repository,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: widget.editing ? Text(l.editChildren) : null,
        actions: const [LanguageButton()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text('🎈', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 8),
              Text(l.onboardingTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(l.onboardingSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < _ages.length; i++)
                    InputChip(
                      label: Text(l.childAge(_ages[i])),
                      onDeleted: () => setState(() => _ages.removeAt(i)),
                    ),
                  ActionChip(
                    avatar: const Icon(Icons.add),
                    label: Text(l.addChild),
                    onPressed: _addChild,
                  ),
                ],
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _ages.isEmpty ? null : _save,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(l.continueButton,
                        style: const TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
