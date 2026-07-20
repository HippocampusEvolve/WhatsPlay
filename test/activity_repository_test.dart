import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:whatsplay/data/activity_repository.dart';

const validLocations = {'home', 'yard', 'city', 'village', 'nature'};
const validEnergy = {'active', 'calm'};

void main() {
  final repo = ActivityRepository.fromJsonString(
    File('assets/activities/activities.json').readAsStringSync(),
  );

  group('База игр', () {
    test('загружается и содержит не меньше 30 игр', () {
      expect(repo.all.length, greaterThanOrEqualTo(30));
    });

    test('все id уникальны', () {
      final ids = repo.all.map((a) => a.id).toSet();
      expect(ids.length, repo.all.length);
    });

    test('каждая игра заполнена корректно на двух языках', () {
      for (final a in repo.all) {
        for (final lang in ['ru', 'en']) {
          expect(a.titleIn(lang).trim(), isNotEmpty, reason: '${a.id}: title.$lang');
          expect(a.descriptionIn(lang).trim(), isNotEmpty,
              reason: '${a.id}: description.$lang');
          expect(a.originIn(lang).trim(), isNotEmpty,
              reason: '${a.id}: origin.$lang');
          final safety = a.safetyIn(lang);
          if (safety != null) {
            expect(safety.trim(), isNotEmpty, reason: '${a.id}: safety.$lang');
          }
        }
        for (final v in a.variants) {
          for (final lang in ['ru', 'en']) {
            expect(v.originIn(lang).trim(), isNotEmpty,
                reason: '${a.id}: variant origin.$lang');
            expect(v.textIn(lang).trim(), isNotEmpty,
                reason: '${a.id}: variant text.$lang');
          }
        }
        expect(a.emoji.trim(), isNotEmpty, reason: '${a.id}: emoji');
        expect(a.ageMin, lessThanOrEqualTo(a.ageMax), reason: '${a.id}: ages');
        expect(a.ageMin, greaterThanOrEqualTo(1), reason: '${a.id}: age_min');
        expect(a.playersMin, greaterThanOrEqualTo(1),
            reason: '${a.id}: players_min');
        expect(a.locations, isNotEmpty, reason: '${a.id}: locations');
        for (final loc in a.locations) {
          expect(validLocations, contains(loc), reason: '${a.id}: $loc');
        }
        expect(validEnergy, contains(a.energy), reason: '${a.id}: energy');
      }
    });

    test('для каждого места и возраста 3–10 лет есть хотя бы 3 игры', () {
      for (final loc in validLocations) {
        for (var age = 3; age <= 10; age++) {
          final found = repo.filter(childAges: [age], location: loc);
          expect(found.length, greaterThanOrEqualTo(3),
              reason: 'мало игр: место=$loc, возраст=$age');
        }
      }
    });
  });

  group('Фильтрация и выбор', () {
    test('filter возвращает только подходящие по месту и возрасту', () {
      final found = repo.filter(childAges: [5], location: 'home');
      for (final a in found) {
        expect(a.locations, contains('home'));
        expect(5, inInclusiveRange(a.ageMin, a.ageMax));
      }
    });

    test('игра подходит, если хотя бы один ребёнок в возрастной вилке', () {
      final onlyBig = repo.filter(childAges: [14], location: 'yard');
      final mixed = repo.filter(childAges: [3, 14], location: 'yard');
      expect(mixed.length, greaterThanOrEqualTo(onlyBig.length));
    });

    test('pick не повторяет недавние игры, пока есть другие варианты', () {
      final rng = Random(42);
      final first = repo.pick(childAges: [7], location: 'yard', random: rng)!;
      for (var i = 0; i < 20; i++) {
        final next = repo.pick(
          childAges: [7],
          location: 'yard',
          recentIds: [first.id],
          random: rng,
        )!;
        expect(next.id, isNot(first.id));
      }
    });

    test('pick возвращает null, когда ничего не подходит', () {
      expect(repo.pick(childAges: [], location: 'home'), isNull);
    });
  });
}
