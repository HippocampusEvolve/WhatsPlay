import 'package:flutter/material.dart';

import '../data/activity_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/activity.dart';
import '../services/app_settings.dart';
import 'locations.dart';

/// Карточка игры: описание, происхождение, реквизит + кнопка «Ещё вариант».
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({
    super.key,
    required this.initial,
    required this.repository,
    required this.settings,
    this.location,
  });

  final Activity initial;
  final ActivityRepository repository;
  final AppSettings settings;

  /// Если null — открыто из избранного, кнопка «Ещё вариант» скрыта.
  final String? location;

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // История показанных игр: можно листать не только вперёд, но и назад.
  late final List<Activity> _history = [widget.initial];
  int _index = 0;

  Activity get _activity => _history[_index];

  void _another() {
    // Если уходили назад — сначала идём вперёд по уже показанным.
    if (_index < _history.length - 1) {
      setState(() => _index++);
      return;
    }
    final recent =
        _history.map((a) => a.id).toList().reversed.take(10).toList();
    final next = widget.repository.pick(
      childAges: widget.settings.childAges,
      location: widget.location!,
      recentIds: recent,
    );
    if (next == null) return;
    setState(() {
      _history.add(next);
      _index++;
    });
  }

  void _previous() {
    if (_index > 0) setState(() => _index--);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final lang = contentLang(context);
    final theme = Theme.of(context);
    final isFav = widget.settings.isFavorite(_activity.id);
    final props = _activity.propsIn(lang);
    final safety = _activity.safetyIn(lang);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            tooltip: isFav ? l.savedToFavorites : l.addToFavorites,
            onPressed: () async {
              await widget.settings.toggleFavorite(_activity.id);
              setState(() {});
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(_activity.emoji,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 8),
                  Text(_activity.titleIn(lang),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Center(
                    child: Chip(
                      avatar: const Icon(Icons.public, size: 18),
                      label: Text(_activity.originIn(lang)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(_activity.descriptionIn(lang),
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.4)),
                  const SizedBox(height: 20),
                  _InfoRow(
                    icon: Icons.cake,
                    label: l.agesLabel,
                    value: l.agesValue(_activity.ageMin, _activity.ageMax),
                  ),
                  _InfoRow(
                    icon: Icons.groups,
                    label: l.playersLabel,
                    value: l.playersValue(_activity.playersMin),
                  ),
                  _InfoRow(
                    icon: Icons.backpack,
                    label: l.propsLabel,
                    value: props.isEmpty ? l.propsNothing : props,
                  ),
                  if (safety != null) ...[
                    const SizedBox(height: 12),
                    Card(
                      color: theme.colorScheme.tertiaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_amber),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text('${l.safetyLabel}: $safety'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (_activity.variants.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.travel_explore,
                            size: 20, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(l.variantsLabel,
                              style: theme.textTheme.titleMedium),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (final v in _activity.variants)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${v.originIn(lang)}: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: v.textIn(lang)),
                            ],
                          ),
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(height: 1.35),
                        ),
                      ),
                  ],
                ],
              ),
            ),
            if (widget.location != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    if (_index > 0) ...[
                      OutlinedButton(
                        onPressed: _previous,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          minimumSize: const Size(56, 56),
                        ),
                        child: const Icon(Icons.chevron_left, size: 28),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _another,
                        icon: const Icon(Icons.casino),
                        label: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(l.anotherIdea,
                              style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Text('$label: ', style: theme.textTheme.titleSmall),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
