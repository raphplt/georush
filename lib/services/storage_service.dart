import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Sauver le nom du joueur
  static Future<void> savePlayerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('playerName', name);
  }

  // Récupérer le nom du joueur
  static Future<String?> getPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('playerName');
  }

  // Sauver le score
  static Future<void> savePlayerScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('playerScore', score);
  }

  // Récupérer le score
  static Future<int?> getPlayerScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('playerScore');
  }

  // Reset toutes les données (si besoin reset player)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
