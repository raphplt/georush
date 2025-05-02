import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/map_widget.dart';
import '../models/game_logic.dart';
import '../helpers/map_helper.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLogic gameLogic;
  late MapHelper mapHelper;
  List<Marker> mapMarkers = [];
  List<Polygon> countryPolygons = [];
  bool isLoading = true;
  String lastLoadedCountry = '';
  @override
  void initState() {
    super.initState();
    
    gameLogic = GameLogic();
    mapHelper = MapHelper();
    
    gameLogic.addListener(_updateUI);
    
    _loadCurrentMarker();
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
  
  Future<void> _loadCurrentMarker() async {
    setState(() {
      isLoading = true;
      mapMarkers.clear();
      countryPolygons.clear();
    });

    lastLoadedCountry = gameLogic.correctAnswer;

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
    }
  }
  
  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('Partie terminée'),
            content: Text('Votre score: ${gameLogic.score}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Retour au menu'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    gameLogic = GameLogic();
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
                  children: List.generate(
                    gameLogic.lives,
                    (index) =>
                        Icon(Icons.favorite, color: Colors.red, size: 20),
                  ),
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
              children: [
                _buildTimerBar(), Spacer(), _buildAnswerOptions()],
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
