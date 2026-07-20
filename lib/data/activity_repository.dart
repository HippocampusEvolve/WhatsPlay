import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import '../models/activity.dart';

/// Оффлайн-база игр: загрузка из assets, фильтрация, случайный выбор.
class ActivityRepository {
  ActivityRepository(this.all);

  final List<Activity> all;

  static ActivityRepository fromJsonString(String jsonString) {
    final data = json.decode(jsonString) as Map<String, dynamic>;
    final list = (data['activities'] as List)
        .map((e) => Activity.fromJson(e as Map<String, dynamic>))
        .toList();
    return ActivityRepository(list);
  }

  static Future<ActivityRepository> load() async {
    final raw =
        await rootBundle.loadString('assets/activities/activities.json');
    return fromJsonString(raw);
  }

  Activity? byId(String id) {
    for (final a in all) {
      if (a.id == id) return a;
    }
    return null;
  }

  List<Activity> filter({
    required List<int> childAges,
    required String location,
  }) {
    return all
        .where((a) => a.matches(childAges: childAges, location: location))
        .toList();
  }

  /// Игры для одного конкретного ребёнка, в которые можно играть в одиночку.
  List<Activity> filterSolo({required int age, required String location}) {
    return all
        .where((a) =>
            a.playersMin == 1 &&
            a.locations.contains(location) &&
            age >= a.ageMin &&
            age <= a.ageMax)
        .toList();
  }

  /// Случайная «одиночная» игра для ребёнка. excludeIds — игры, уже занятые
  /// другими детьми или только что показанные; при нехватке вариантов
  /// исключения ослабляются.
  Activity? pickSolo({
    required int age,
    required String location,
    List<String> excludeIds = const [],
    Random? random,
  }) {
    final rng = random ?? Random();
    final candidates = filterSolo(age: age, location: location);
    if (candidates.isEmpty) return null;
    final fresh =
        candidates.where((a) => !excludeIds.contains(a.id)).toList();
    final pool = fresh.isEmpty ? candidates : fresh;
    return pool[rng.nextInt(pool.length)];
  }

  /// Случайная игра под фильтры. Недавно показанные (recentIds) не повторяем,
  /// пока есть непоказанные варианты.
  Activity? pick({
    required List<int> childAges,
    required String location,
    List<String> recentIds = const [],
    Random? random,
  }) {
    final rng = random ?? Random();
    final candidates = filter(childAges: childAges, location: location);
    if (candidates.isEmpty) return null;
    final fresh =
        candidates.where((a) => !recentIds.contains(a.id)).toList();
    final pool = fresh.isEmpty ? candidates : fresh;
    return pool[rng.nextInt(pool.length)];
  }
}
