/// Вариант игры в другой стране или эпохе.
class ActivityVariant {
  const ActivityVariant({required this.origin, required this.text});

  final Map<String, String> origin;
  final Map<String, String> text;

  factory ActivityVariant.fromJson(Map<String, dynamic> json) =>
      ActivityVariant(
        origin: Map<String, String>.from(json['origin'] as Map),
        text: Map<String, String>.from(json['text'] as Map),
      );

  String originIn(String lang) => origin[lang] ?? origin['en'] ?? '';
  String textIn(String lang) => text[lang] ?? text['en'] ?? '';
}

/// Одна игра из базы. Все тексты хранятся в двух языках: ключи 'ru' и 'en'.
class Activity {
  const Activity({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    required this.origin,
    required this.ageMin,
    required this.ageMax,
    required this.locations,
    required this.playersMin,
    required this.energy,
    required this.props,
    this.safety,
    this.variants = const [],
  });

  final String id;
  final String emoji;
  final Map<String, String> title;
  final Map<String, String> description;
  final Map<String, String> origin;
  final int ageMin;
  final int ageMax;
  final List<String> locations;
  final int playersMin;
  final String energy; // 'active' | 'calm'
  final Map<String, String> props;
  final Map<String, String>? safety;
  final List<ActivityVariant> variants;

  factory Activity.fromJson(Map<String, dynamic> json) {
    Map<String, String> text(String key) =>
        Map<String, String>.from(json[key] as Map);
    return Activity(
      id: json['id'] as String,
      emoji: json['emoji'] as String,
      title: text('title'),
      description: text('description'),
      origin: text('origin'),
      ageMin: json['age_min'] as int,
      ageMax: json['age_max'] as int,
      locations: List<String>.from(json['locations'] as List),
      playersMin: json['players_min'] as int,
      energy: json['energy'] as String,
      props: text('props'),
      safety: json['safety'] == null ? null : text('safety'),
      variants: json['variants'] == null
          ? const []
          : (json['variants'] as List)
              .map((v) => ActivityVariant.fromJson(v as Map<String, dynamic>))
              .toList(),
    );
  }

  String titleIn(String lang) => title[lang] ?? title['en'] ?? '';
  String descriptionIn(String lang) => description[lang] ?? description['en'] ?? '';
  String originIn(String lang) => origin[lang] ?? origin['en'] ?? '';
  String propsIn(String lang) => props[lang] ?? props['en'] ?? '';
  String? safetyIn(String lang) =>
      safety == null ? null : (safety![lang] ?? safety!['en']);

  /// Подходит ли игра: место совпадает и хотя бы один ребёнок попадает в возраст.
  bool matches({required List<int> childAges, required String location}) {
    if (!locations.contains(location)) return false;
    return childAges.any((a) => a >= ageMin && a <= ageMax);
  }
}
