import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
        // Vérifier si nous avons une nouvelle question
        if (lastLoadedCountry != gameLogic.correctAnswer) {
          _loadCurrentMarker();
        }
        
        // Afficher l'écran de fin de jeu si c'est terminé
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
    });
    
    // Mémoriser le pays que nous sommes en train de charger
    lastLoadedCountry = gameLogic.correctAnswer;
    
    final countryLocation = await gameLogic.loadCountryMarker();
    
    if (countryLocation != null && mounted) {
      setState(() {
        mapMarkers.add(mapHelper.createLocationMarker(countryLocation));
        isLoading = false;
      });
      
      // Centrer la carte sur le pays
      mapHelper.centerOnLocation(countryLocation, 5.0);
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
                  // Réinitialiser le jeu
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
        title: Text('Geo Rush - Jeu'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'Score: ${gameLogic.score}',
                style: TextStyle(fontSize: 18),
              ),
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
              Color? buttonColor;
              if (gameLogic.showingFeedback) {
                if (option == gameLogic.correctAnswer) {
                  buttonColor = Colors.green;
                } else if (option == gameLogic.selectedAnswer &&
                    gameLogic.selectedAnswer != gameLogic.correctAnswer) {
                  buttonColor = Colors.red;
                }
              }

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: buttonColor,
                  foregroundColor: buttonColor != null ? Colors.white : null,
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
