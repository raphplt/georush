import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/load_geojson.dart';
import '../data/countries.dart';

class GameLogic extends ChangeNotifier {
  int score = 0;
  int timeLeft = 30;
  int initialTime = 30;
  List<String> options = [];
  String correctAnswer = '';
  List<Marker> mapMarkers = [];
  Timer? _timer;
  Random random = Random();

  List<String> usedCountries = [];

  final int optionsCount = 4;

  bool isGameOver = false;

  String? selectedAnswer;
  bool? isLastAnswerCorrect;
  bool showingFeedback = false;

  GameLogic() {
    loadNewQuestion();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        timeLeft--;
        notifyListeners();
      } else {
        endGame();
      }
    });
  }

  void resetTimer() {
    timeLeft = initialTime;
    notifyListeners();
  }

  void loadNewQuestion() {
    mapMarkers.clear();

    // Sélectionner un pays aléatoire qui n'a pas été utilisé récemment
    final Country correctCountry = _getRandomCountry();
    correctAnswer = correctCountry.name;

    // Mémoriser ce pays pour éviter la répétition immédiate
    usedCountries.add(correctAnswer);
    if (usedCountries.length > 10) {
      // Conserver seulement les 10 derniers pays pour permettre leur réutilisation ultérieure
      usedCountries.removeAt(0);
    }

    // Générer les options, dont l'une est la bonne réponse
    options = _generateOptions(correctCountry);

    notifyListeners();
  }

  List<String> _generateOptions(Country correctCountry) {
    // Commencer avec la bonne réponse
    List<String> result = [correctCountry.name];

    // Liste temporaire pour exclure les pays déjà utilisés et le pays correct
    List<Country> availableCountries =
        Countries.all
            .where((country) => country.name != correctCountry.name)
            .toList();

    // Préférer des pays du même continent pour un défi plus intéressant
    List<Country> sameContinent =
        availableCountries
            .where((country) => country.continent == correctCountry.continent)
            .toList();

    // Mélanger la liste des pays du même continent
    sameContinent.shuffle(random);

    // Ajouter prioritairement 2 pays du même continent si possible
    int continentCount = min(2, sameContinent.length);
    for (int i = 0; i < continentCount; i++) {
      result.add(sameContinent[i].name);
    }

    // Si on n'a pas assez de pays du même continent, compléter avec des pays aléatoires
    if (result.length < optionsCount) {
      // Exclure les pays déjà dans les options
      availableCountries.removeWhere(
        (country) => result.contains(country.name),
      );
      availableCountries.shuffle(random);

      // Compléter jusqu'à avoir 4 options
      while (result.length < optionsCount && availableCountries.isNotEmpty) {
        result.add(availableCountries.removeAt(0).name);
      }
    }

    // Mélanger pour que la bonne réponse ne soit pas toujours en première position
    result.shuffle(random);

    return result;
  }

  Country _getRandomCountry() {
    // Filtrer les pays déjà utilisés récemment
    List<Country> availableCountries =
        Countries.all
            .where((country) => !usedCountries.contains(country.name))
            .toList();

    // Si on a épuisé la liste, réinitialiser
    if (availableCountries.isEmpty) {
      availableCountries = Countries.all;
    }

    // Choisir un pays au hasard
    return availableCountries[random.nextInt(availableCountries.length)];
  }

  void checkAnswer(String selectedOption) {
    _timer?.cancel();

    selectedAnswer = selectedOption;
    bool isCorrect = selectedOption == correctAnswer;
    isLastAnswerCorrect = isCorrect;
    showingFeedback = true;

    notifyListeners();

    if (isCorrect) {
      int timeBonus = (timeLeft / initialTime * 5).round();
      score += 10 + timeBonus;

      Future.delayed(Duration(milliseconds: 1500), () {
        showingFeedback = false;
        selectedAnswer = null;
        isLastAnswerCorrect = null;
        loadNewQuestion();
        // Redémarrer le timer
        resetTimer();
        startTimer();
      });
    } else {
      timeLeft = max(timeLeft - 5, 0);

      Future.delayed(Duration(milliseconds: 1000), () {
        showingFeedback = false;
        selectedAnswer = null;
        isLastAnswerCorrect = null;
        notifyListeners();

        if (timeLeft <= 0) {
          endGame();
        } else {
          startTimer();
        }
      });
    }
  }

  void endGame() {
    isGameOver = true;
    _timer?.cancel();
    notifyListeners();
  }

  Future<LatLng?> loadCountryMarker() async {
    try {
      final geoJsonData = await loadGeoJson();
      final features = geoJsonData['features'] as List;

      for (var feature in features) {
        final properties = feature['properties'] as Map<String, dynamic>;
        final countryName = properties['name'] as String;

        if (countryName == correctAnswer) {
          final geometry = feature['geometry'];
          return extractCentroid(geometry);
        }
      }
    } catch (e) {
      print('Error loading GeoJSON: $e');
    }
    return null;
  }

  LatLng? extractCentroid(Map<String, dynamic> geometry) {
    final type = geometry['type'];

    if (type == 'Polygon') {
      final coordinates = geometry['coordinates'][0] as List;
      double lat = 0, lng = 0;

      for (var coord in coordinates) {
        lng += coord[0] as double;
        lat += coord[1] as double;
      }

      return LatLng(lat / coordinates.length, lng / coordinates.length);
    } else if (type == 'MultiPolygon') {
      final polygons = geometry['coordinates'] as List;
      int maxPoints = 0;
      LatLng? centroid;

      for (var polygon in polygons) {
        final coords = polygon[0] as List;
        if (coords.length > maxPoints) {
          maxPoints = coords.length;

          double lat = 0, lng = 0;
          for (var coord in coords) {
            lng += coord[0] as double;
            lat += coord[1] as double;
          }

          centroid = LatLng(lat / coords.length, lng / coords.length);
        }
      }

      return centroid;
    }
    return null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
