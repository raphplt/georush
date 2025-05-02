import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  // Sauver le score d'un mode de jeu spécifique
  static Future<void> saveGameModeScore(String gameMode, int score) async {
    final prefs = await SharedPreferences.getInstance();

    // Récupérer les scores existants ou créer un nouveau Map
    Map<String, int> scores = await getGameModeScores() ?? {};

    // Mettre à jour le score uniquement s'il est meilleur que l'ancien
    if (!scores.containsKey(gameMode) || scores[gameMode]! < score) {
      scores[gameMode] = score;
      // Sauvegarder le Map mis à jour
      await prefs.setString('gameModeScores', jsonEncode(scores));
    }
  }

  // Récupérer tous les scores des modes de jeu
  static Future<Map<String, int>?> getGameModeScores() async {
    final prefs = await SharedPreferences.getInstance();
    final String? scoresJson = prefs.getString('gameModeScores');

    if (scoresJson == null) return null;

    Map<String, dynamic> decodedMap = jsonDecode(scoresJson);
    Map<String, int> scores = {};

    decodedMap.forEach((key, value) {
      scores[key] = value as int;
    });

    return scores;
  }

  // Récupérer le score d'un mode de jeu spécifique
  static Future<int?> getGameModeScore(String gameMode) async {
    final scores = await getGameModeScores();
    return scores?[gameMode];
  }

  // Pour maintenir la compatibilité avec le code existant
  static Future<int?> getCountryScore() async {
    return await getGameModeScore('country');
  }

  // Pour maintenir la compatibilité avec le code existant
  static Future<void> saveCountryScore(String country, int score) async {
    await saveGameModeScore('country_$country', score);
  }

  // Reset toutes les données (si besoin reset player)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Reset uniquement les scores des modes de jeu
  static Future<void> clearGameModeScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('gameModeScores');
  }
}
