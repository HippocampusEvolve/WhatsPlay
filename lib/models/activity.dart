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
