import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/map_widget.dart';
import '../services/load_geojson.dart';
import '../data/countries.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int timeLeft = 30;
  late final List<String> options;
  String correctAnswer = 'France';
  List<Marker> mapMarkers = [];

  // Ajout du contrôleur de carte
  final MapController _mapController = MapController();
  // Coordonnées initiales (centrées sur la France)
  final LatLng _initialPosition = LatLng(46.603354, 1.888334);

  @override
  void initState() {
    super.initState();
    startTimer();
    loadQuestion();
    loadCountryMarker();
  }

  @override
  void dispose() {
    // Libérer les ressources du contrôleur
    _mapController.dispose();
    super.dispose();
  }

  Future<void> loadCountryMarker() async {
    try {
      // Charger le fichier GeoJSON
      final geoJsonData = await loadGeoJson();

      // Parcourir les entités (features) du GeoJSON
      final features = geoJsonData['features'] as List;

      for (var feature in features) {
        final properties = feature['properties'] as Map<String, dynamic>;
        // Utiliser "name" au lieu de "ADMIN"
        final countryName = properties['name'] as String;

        // Chercher la France
        if (countryName == 'France') {
          // Extraire la géométrie
          final geometry = feature['geometry'];
          final coordinates = extractCentroid(geometry);

          if (coordinates != null) {
            setState(() {
              log('Coordonnées de la France : $coordinates');
              // Ajouter un marker pour la France
              mapMarkers.add(
                Marker(
                  point: coordinates,
                  width: 40,
                  height: 40,
                  child: Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
              );
            });

            // Centrer la carte sur la France
            _mapController.move(coordinates, 5.0);
          }
          break; // Sortir de la boucle une fois la France trouvée
        }
      }
    } catch (e) {
      print('Erreur lors du chargement du GeoJSON: $e');
    }
  }

  // Extraire le centroïde d'une géométrie GeoJSON
  LatLng? extractCentroid(Map<String, dynamic> geometry) {
    final type = geometry['type'];

    if (type == 'Polygon') {
      // Pour un polygone simple, prendre le centroïde approximatif
      final coordinates = geometry['coordinates'][0] as List;
      double lat = 0, lng = 0;

      for (var coord in coordinates) {
        lng += coord[0] as double;
        lat += coord[1] as double;
      }

      return LatLng(lat / coordinates.length, lng / coordinates.length);
    } else if (type == 'MultiPolygon') {
      // Pour un multipolygone, prendre le plus grand polygone
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

  void startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
        startTimer();
      } else {
        // TODO : Gérer fin du timer (ex: montrer mauvaise réponse)
      }
    });
  }

  void loadQuestion() {
    // Pour l'instant, question fixe de test
    options = ['France', 'Allemagne', 'Italie', 'Espagne'];
  }

  void checkAnswer(String selectedOption) {
    if (selectedOption == correctAnswer) {
      setState(() {
        score += 10; // +10 points pour bonne réponse
      });
      // TODO : Passer à la prochaine question
    } else {
      // TODO : Réduire vies / montrer erreur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geo Rush - Jeu'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text('Score: $score', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Carte en arrière-plan
          ReusableMap(
            mapController: _mapController,
            center: _initialPosition,
            zoom: 5.0,
            markers: mapMarkers, // Passer les marqueurs à la carte
            showZoomControls: false,
          ),

          // Contenu du jeu superposé
          SafeArea(
            child: Column(
              children: [
                // Timer en haut
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(8),
                    child: LinearProgressIndicator(
                      value: timeLeft / 30, // Barre qui se vide
                      color: Colors.blue,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                ),

                Spacer(), // Pousse les réponses vers le bas
                // Liste des réponses en bas
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children:
                        options.map((option) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => checkAnswer(option),
                          child: Text(option, style: TextStyle(fontSize: 18)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
