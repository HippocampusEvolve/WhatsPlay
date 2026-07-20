import 'package:flutter/material.dart';

import '../data/activity_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/activity.dart';
import '../services/app_settings.dart';
import 'activity_screen.dart';
import 'locations.dart';

/// Сохранённые игры.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
    required this.settings,
    required this.repository,
  });

  final AppSettings settings;
  final ActivityRepository repository;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final lang = contentLang(context);
    final favs = widget.settings.favorites
        .map(widget.repository.byId)
        .whereType<Activity>()
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(l.favoritesTitle)),
      body: favs.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(l.favoritesEmpty, textAlign: TextAlign.center),
              ),
            )
          : ListView.builder(
              itemCount: favs.length,
              itemBuilder: (context, i) {
                final a = favs[i];
                return ListTile(
                  leading: Text(a.emoji, style: const TextStyle(fontSize: 28)),
                  title: Text(a.titleIn(lang)),
                  subtitle: Text(a.originIn(lang)),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ActivityScreen(
                          initial: a,
                          repository: widget.repository,
                          settings: widget.settings,
                        ),
                      ),
                    );
                    setState(() {});
                  },
                );
              },
            ),
    );
  }
}
