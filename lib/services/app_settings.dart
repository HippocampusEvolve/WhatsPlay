import 'package:shared_preferences/shared_preferences.dart';

/// Хранит анкету (возраст детей), избранное и последнее выбранное место.
class AppSettings {
  AppSettings(this._prefs);

  static const _kChildAges = 'child_ages';
  static const _kFavorites = 'favorites';
  static const _kLocation = 'last_location';

  final SharedPreferences _prefs;

  static Future<AppSettings> load() async =>
      AppSettings(await SharedPreferences.getInstance());

  List<int> get childAges =>
      (_prefs.getStringList(_kChildAges) ?? []).map(int.parse).toList();

  Future<void> setChildAges(List<int> ages) => _prefs.setStringList(
      _kChildAges, ages.map((a) => a.toString()).toList());

  bool get hasChildren => childAges.isNotEmpty;

  List<String> get favorites => _prefs.getStringList(_kFavorites) ?? [];

  Future<void> toggleFavorite(String id) {
    final favs = favorites;
    if (favs.contains(id)) {
      favs.remove(id);
    } else {
      favs.add(id);
    }
    return _prefs.setStringList(_kFavorites, favs);
  }

  bool isFavorite(String id) => favorites.contains(id);

  String get lastLocation => _prefs.getString(_kLocation) ?? 'home';

  Future<void> setLastLocation(String location) =>
      _prefs.setString(_kLocation, location);
}
