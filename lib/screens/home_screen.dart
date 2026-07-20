import 'package:flutter/material.dart';

import '../data/activity_repository.dart';
import '../l10n/app_localizations.dart';
import '../services/app_settings.dart';
import 'activity_screen.dart';
import 'favorites_screen.dart';
import 'language_button.dart';
import 'locations.dart';
import 'onboarding_screen.dart';

/// Главный экран: где вы находитесь + большая кнопка «Чем заняться?».
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.settings,
    required this.repository,
  });

  final AppSettings settings;
  final ActivityRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _location = widget.settings.lastLocation;

  void _play() {
    final l = AppLocalizations.of(context)!;
    final activity = widget.repository.pick(
      childAges: widget.settings.childAges,
      location: _location,
    );
    if (activity == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.noMatch)));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActivityScreen(
          initial: activity,
          repository: widget.repository,
          settings: widget.settings,
          location: _location,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final ages = widget.settings.childAges;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          const LanguageButton(),
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: l.favoritesTitle,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FavoritesScreen(
                  settings: widget.settings,
                  repository: widget.repository,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.family_restroom),
            tooltip: l.editChildren,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OnboardingScreen(
                    settings: widget.settings,
                    repository: widget.repository,
                    editing: true,
                  ),
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.kidsLine(ages.map((a) => l.childAge(a)).join(', ')),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(l.whereAreYou,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    for (final loc in kLocations)
                      _LocationCard(
                        emoji: loc.emoji,
                        label: locationLabel(context, loc.key),
                        selected: _location == loc.key,
                        onTap: () {
                          setState(() => _location = loc.key);
                          widget.settings.setLastLocation(loc.key);
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _play,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l.whatToPlay,
                        style: const TextStyle(fontSize: 20)),
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

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: selected ? scheme.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: selected
            ? BorderSide(color: scheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}
