import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchService {
  static const String _key = 'recent_searches';
  static const int maxItems = 10;

  static Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> addSearch(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> searches = prefs.getStringList(_key) ?? [];

    searches.remove(keyword); // tránh trùng
    searches.insert(0, keyword);

    if (searches.length > maxItems) {
      searches = searches.sublist(0, maxItems);
    }

    await prefs.setStringList(_key, searches);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
