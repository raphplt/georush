import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/french_cities.dart';

class GameLogicCities extends ChangeNotifier {
  int score = 0;
  int timeLeft = 30;
  int maxScore = 0;
  int lives = 3;
  int initialTime = 30;
  String currentCity = '';
  LatLng? currentCityLocation;
  LatLng? playerMarkerLocation;
  Marker? playerMarker;
  Marker? actualCityMarker;
  Timer? _timer;
  Random random = Random();
  List<String> usedCities = [];
  bool isGameOver = false;
  bool showingFeedback = false;
  double? distance;
  int? pointsEarned;
  bool isAnimating = false;
  double animationProgress = 0.0;

  GameLogicCities({String difficulty = 'Facile', String mode = '3 vies'}) {
    switch (difficulty) {
      case 'Facile':
        initialTime = 30;
        break;
      case 'Moyen':
        initialTime = 20;
        break;
      case 'Difficile':
        initialTime = 10;
        break;
      default:
        initialTime = 30;
    }
    timeLeft = initialTime;

    if (mode == 'Illimité') {
      lives = 9999;
    } else {
      lives = 3;
    }

    loadNewCity();
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

  void loadNewCity() {
    final City city = _getRandomCity();
    currentCity = city.name;
    currentCityLocation = LatLng(
      double.parse(city.latitude),
      double.parse(city.longitude),
    );
    playerMarker = null;
    playerMarkerLocation = null;
    actualCityMarker = null;
    distance = null;
    pointsEarned = null;
    isAnimating = false;
    animationProgress = 0.0;
    usedCities.add(currentCity);
    
    if (usedCities.length > 20) {
      usedCities.removeAt(0);
    }

    notifyListeners();
  }

  City _getRandomCity() {
    List<City> availableCities =
        FrenchCities.cities
            .where((city) => !usedCities.contains(city.name))
            .toList();

    if (availableCities.isEmpty) {
      availableCities = FrenchCities.cities;
    }

    return availableCities[random.nextInt(availableCities.length)];
  }

  void placeMarker(LatLng location) {
    playerMarkerLocation = location;
    playerMarker = Marker(
      point: location,
      width: 30,
      height: 30,
      child: Icon(Icons.location_on, color: Colors.red, size: 30),
    );
    notifyListeners();
  }

  void validateAnswer() {
    if (playerMarkerLocation == null || currentCityLocation == null) return;

    _timer?.cancel();
    
    // Calculate distance between player marker and actual city location
    final Distance distanceCalculator = Distance();
    distance = distanceCalculator.as(
      LengthUnit.Kilometer,
      playerMarkerLocation!,
      currentCityLocation!,
    );

    // Calculate points based on distance
    pointsEarned = _calculatePoints(distance!);
    score += pointsEarned!;
    maxScore = max(maxScore, score);

    // Show actual city location
    actualCityMarker = Marker(
      point: currentCityLocation!,
      width: 30,
      height: 30,
      child: Icon(Icons.location_city, color: Colors.blue, size: 30),
    );

    showingFeedback = true;
    isAnimating = true;
    notifyListeners();

    // Start animation
    Timer.periodic(Duration(milliseconds: 16), (timer) {
      if (animationProgress < 1.0) {
        animationProgress += 0.02;
        notifyListeners();
      } else {
        timer.cancel();
        isAnimating = false;
        notifyListeners();
      }
    });

    Future.delayed(Duration(seconds: 3), () {
      showingFeedback = false;
      if (lives <= 0) {
        endGame();
      } else {
        loadNewCity();
        resetTimer();
        startTimer();
      }
    });
  }

  int _calculatePoints(double distance) {
    // Perfect score (within 1km) = 100 points
    // 0 points if more than 100km away
    if (distance <= 1) return 100;
    if (distance >= 100) return 0;

    // Linear interpolation between 100 and 0 points
    return (100 * (1 - (distance - 1) / 99)).round();
  }

  void endGame() {
    isGameOver = true;
    _timer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
