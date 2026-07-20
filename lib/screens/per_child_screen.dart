import 'package:flutter/material.dart';

import '../data/activity_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/activity.dart';
import '../services/app_settings.dart';
import 'activity_screen.dart';
import 'locations.dart';

/// Режим «Каждому своё»: каждому ребёнку — своя одиночная игра под возраст.
class PerChildScreen extends StatefulWidget {
  const PerChildScreen({
    super.key,
    required this.settings,
    required this.repository,
    required this.location,
  });

  final AppSettings settings;
  final ActivityRepository repository;
  final String location;

  @override
  State<PerChildScreen> createState() => _PerChildScreenState();
}

class _PerChildScreenState extends State<PerChildScreen> {
  late final List<int> _ages = widget.settings.childAges;
  late List<Activity?> _picks;

  @override
  void initState() {
    super.initState();
    _picks = List.filled(_ages.length, null);
    _shuffleAll();
  }

  /// Игры, занятые другими детьми (кроме child) — чтобы не выдать одну на двоих.
  List<String> _takenIds({int? except}) => [
        for (var i = 0; i < _picks.length; i++)
          if (i != except && _picks[i] != null) _picks[i]!.id,
      ];

  void _shuffleAll() {
    setState(() {
      for (var i = 0; i < _ages.length; i++) {
        _picks[i] = widget.repository.pickSolo(
          age: _ages[i],
          location: widget.location,
          excludeIds: _takenIds(except: i),
        );
      }
    });
  }

  void _reroll(int i) {
    setState(() {
      _picks[i] = widget.repository.pickSolo(
        age: _ages[i],
        location: widget.location,
        excludeIds: [..._takenIds(except: i), if (_picks[i] != null) _picks[i]!.id],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final lang = contentLang(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.forEachChild)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _ages.length,
                itemBuilder: (context, i) {
                  final a = _picks[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: a == null
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                                '${l.childAge(_ages[i])} — ${l.noMatch}'),
                          )
                        : ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: Text(a.emoji,
                                style: const TextStyle(fontSize: 36)),
                            title: Text(
                              '${l.childAge(_ages[i])} · '
                              '${a.energy == 'active' ? l.energyActive : l.energyCalm}',
                              style: theme.textTheme.bodySmall,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                a.titleIn(lang),
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.casino),
                              tooltip: l.anotherIdea,
                              onPressed: () => _reroll(i),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ActivityScreen(
                                  initial: a,
                                  repository: widget.repository,
                                  settings: widget.settings,
                                ),
                              ),
                            ),
                          ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: _shuffleAll,
                  icon: const Icon(Icons.shuffle),
                  label: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(l.shuffleAll,
                        style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
