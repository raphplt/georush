import 'package:georush/services/storage_service.dart';

class GameMode {
  static const String COUNTRY = 'country';
  static const String CITY = 'city';
  static const String FLAG = 'flag';
  static const String MONUMENT = 'monument';
  // Ajouter d'autres modes de jeu selon les besoins
}

class GameService {
  static final GameService _instance = GameService._internal();

  factory GameService() {
    return _instance;
  }

  GameService._internal();

  // Charger tous les scores des modes de jeu
  static Future<Map<String, int>> loadAllGameScores() async {
    final scores = await StorageService.getGameModeScores();
    return scores ?? {};
  }

  // Charger le score d'un mode de jeu spécifique
  static Future<int> loadGameModeScore(String gameMode) async {
    final score = await StorageService.getGameModeScore(gameMode);
    return score ?? 0;
  }

  // Sauvegarder le score d'un mode de jeu
  static Future<void> saveGameModeScore(String gameMode, int score) async {
    await StorageService.saveGameModeScore(gameMode, score);
  }

  // Sauvegarder le score d'une partie spécifique d'un pays
  static Future<void> saveCountryScore(String countryCode, int score) async {
    await StorageService.saveGameModeScore(
      '${GameMode.COUNTRY}_$countryCode',
      score,
    );
  }

  // Obtenir le score d'une partie spécifique d'un pays
  static Future<int> getCountryScore(String countryCode) async {
    final score = await StorageService.getGameModeScore(
      '${GameMode.COUNTRY}_$countryCode',
    );
    return score ?? 0;
  }

  // Pour la rétrocompatibilité avec le code existant
  static Future<Map<String, dynamic>> loadGameData() async {
    final scores = await loadAllGameScores();

    // Création d'un map avec tous les scores des modes de jeu
    Map<String, dynamic> gameData = {
      'countryScore': scores[GameMode.COUNTRY] ?? 0,
      'cityScore': scores[GameMode.CITY] ?? 0,
      'flagScore': scores[GameMode.FLAG] ?? 0,
      'monumentScore': scores[GameMode.MONUMENT] ?? 0,
      'allScores': scores,
    };

    return gameData;
  }
}
