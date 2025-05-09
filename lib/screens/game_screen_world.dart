import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:georush/models/game_logic_countries.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/map_widget.dart';
import '../helpers/map_helper.dart';
import '../services/game_service.dart';


class GameScreen extends StatefulWidget {
  final String difficulty;
  final String mode;

  const GameScreen({super.key, required this.difficulty, required this.mode});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLogicCountries gameLogic;
  late MapHelper mapHelper;
  List<Marker> mapMarkers = [];
  List<Polygon> countryPolygons = [];
  bool isLoading = true;
  String lastLoadedCountry = '';
  late String difficulty;
  late String mode;
  int bestScore = 0;

  @override
  void initState() {
    super.initState();

    difficulty = widget.difficulty;
    mode = widget.mode;

    gameLogic = GameLogicCountries(difficulty: difficulty, mode: mode);
    mapHelper = MapHelper();

    gameLogic.addListener(_updateUI);

    _loadCurrentMarker();
    _loadBestScore();
  }


  void _updateUI() {
    if (mounted) {
      setState(() {
        if (lastLoadedCountry != gameLogic.correctAnswer) {
          _loadCurrentMarker();
        }

        if (gameLogic.isGameOver) {
          _showGameOverDialog();
        }
      });
    }
  }

  Future<void> _loadBestScore() async {
    bestScore = await GameService.loadGameModeScore(GameMode.COUNTRY);
    setState(() {});
  }

Future<void> _loadCurrentMarker() async {
    setState(() {
      isLoading = true;
      mapMarkers.clear();
      countryPolygons.clear();
    });

    lastLoadedCountry = gameLogic.correctAnswer;

    try {
      final countryData = await gameLogic.loadCountryGeoJson();

      if (countryData != null && mounted) {
        final geometry = countryData['geometry'];
        final centroid = countryData['centroid'] as LatLng?;

        setState(() {
          countryPolygons = mapHelper.polygonsFromGeoJson(geometry);
          isLoading = false;
        });

        if (centroid != null) {
          mapHelper.centerOnLocation(centroid, 5.0);
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          gameLogic.skipCurrentQuestion();
        }
      }
    } catch (e) {
      print('Error loading country marker: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        gameLogic.skipCurrentQuestion();
      }
    }
  }
  void _showGameOverDialog() {
    if (gameLogic.score > bestScore) {
      GameService.saveGameModeScore(GameMode.COUNTRY, gameLogic.score);
      bestScore = gameLogic.score;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('Partie terminée'),
            content: Text(
              'Votre score: ${gameLogic.score}\nMeilleur score: $bestScore',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Retour au menu'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    gameLogic = GameLogicCountries(
                      difficulty: difficulty,
                      mode: mode,
                    );
                    gameLogic.addListener(_updateUI);
                    lastLoadedCountry = '';
                    mapMarkers.clear();
                    _loadCurrentMarker();
                  });
                },
                child: Text('Rejouer'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    gameLogic.removeListener(_updateUI);
    gameLogic.dispose();
    mapHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Row(
                  children: [
                    if (gameLogic.lives > 10) ...[
                      Icon(Icons.favorite, color: Colors.red, size: 20),
                      SizedBox(width: 4),
                      Text(
                        'Vies infinies',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else ...[
                      for (int i = 0; i < gameLogic.lives; i++)
                        Icon(Icons.favorite, color: Colors.red, size: 20),
                    ],
                  ],
                ),
                SizedBox(width: 12),
                Text(
                  'Score: ${gameLogic.score}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ReusableMap(
            mapController: mapHelper.mapController,
            center: mapHelper.initialPosition,
            zoom: 5.0,
            markers: mapMarkers,
            polygons: countryPolygons,
            showZoomControls: false,
          ),

          if (isLoading) Center(child: CircularProgressIndicator()),

          SafeArea(
            child: Column(
              children: [_buildTimerBar(), Spacer(), _buildAnswerOptions()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              'Quel est ce pays?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            // Text('${gameLogic.timeLeft} sec', style: TextStyle(fontSize: 16)),
            LinearProgressIndicator(
              value: gameLogic.timeLeft / gameLogic.initialTime,
              color: Colors.blue[800],
              backgroundColor: Colors.grey.shade300,
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 2.5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children:
            gameLogic.options.map((option) {
              // Couleur par défaut
              Color backgroundColor =
                  Theme.of(
                    context,
                  ).elevatedButtonTheme.style?.backgroundColor?.resolve({}) ??
                  Colors.blue.shade700;
              Color foregroundColor = Colors.white;

              if (gameLogic.showingFeedback &&
                  option == gameLogic.selectedAnswer) {
                backgroundColor =
                    option == gameLogic.correctAnswer
                        ? Colors.green
                        : Colors.red;
              }

              return ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(backgroundColor),
                  foregroundColor: WidgetStateProperty.all(foregroundColor),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                onPressed:
                    isLoading || gameLogic.showingFeedback
                        ? null
                        : () => gameLogic.checkAnswer(option),
                child: Text(option, style: TextStyle(fontSize: 16)),
              );
            }).toList(),
      ),
    );
  }
}
