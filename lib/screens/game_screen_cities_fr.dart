import 'package:flutter/material.dart';
import 'package:georush/helpers/map_helper_fr.dart';
import 'package:georush/widgets/france_map_widget.dart';
import 'package:georush/models/game_logic_cities.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

class GameScreenCitiesFr extends StatefulWidget {
  final String difficulty;
  final String mode;

  const GameScreenCitiesFr({
    super.key,
    required this.difficulty,
    required this.mode,
  });

  @override
  State<GameScreenCitiesFr> createState() => _GameScreenCitiesFrState();
}

class _GameScreenCitiesFrState extends State<GameScreenCitiesFr> {
  late MapHelperFr mapHelperFr;
  late GameLogicCities gameLogic;

  @override
  void initState() {
    super.initState();
    mapHelperFr = MapHelperFr();
    gameLogic = GameLogicCities(
      difficulty: widget.difficulty,
      mode: widget.mode,
    );
  }

  @override
  void dispose() {
    mapHelperFr.dispose();
    super.dispose();
  }

  void _handleMapTap(LatLng location) {
    if (gameLogic.timeLeft > 0 && !gameLogic.showingFeedback) {
      gameLogic.placeMarker(location);
      gameLogic.validateAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameLogic,
      child: Consumer<GameLogicCities>(
        builder: (context, gameLogic, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Villes de France'),
              backgroundColor: Colors.blue[700],
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          '${gameLogic.score}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                FranceMap(
                  mapController: mapHelperFr.mapController,
                  markers: [
                    if (gameLogic.playerMarker != null) gameLogic.playerMarker!,
                    if (gameLogic.actualCityMarker != null)
                      gameLogic.actualCityMarker!,
                  ],
                  onPositionChanged: (position, hasGesture) {
                    if (hasGesture) {
                      _handleMapTap(position.center);
                    }
                  },
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            gameLogic.currentCity,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: gameLogic.timeLeft / gameLogic.initialTime,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                gameLogic.timeLeft > 10
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              minHeight: 8,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Temps restant: ${gameLogic.timeLeft}s',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (gameLogic.showingFeedback)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: AnimatedOpacity(
                      opacity: gameLogic.isAnimating ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 300),
                      child: Card(
                        elevation: 8,
                        color: Colors.black87,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Distance: ${gameLogic.distance?.toStringAsFixed(1)} km',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Points gagnés: ${gameLogic.pointsEarned}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              if (gameLogic.isAnimating)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: gameLogic.animationProgress,
                                      backgroundColor: Colors.grey[800],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue,
                                      ),
                                      minHeight: 4,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (gameLogic.isGameOver)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Card(
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Partie terminée!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 32,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Score final: ${gameLogic.score}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
                                child: Text(
                                  'Retour au menu',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
