import 'package:flutter/material.dart';
import 'game_screen_cities_fr.dart';

class StartGameCitiesFrScreen extends StatefulWidget {
  const StartGameCitiesFrScreen({super.key});

  @override
  State<StartGameCitiesFrScreen> createState() =>
      _StartGameCitiesFrScreenState();
}

class _StartGameCitiesFrScreenState extends State<StartGameCitiesFrScreen> {
  String selectedDifficulty = 'Facile';
  String selectedMode = '3 vies';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Villes de France'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choisissez la difficulté',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ToggleButtons(
              isSelected: [
                selectedDifficulty == 'Facile',
                selectedDifficulty == 'Moyen',
                selectedDifficulty == 'Difficile',
              ],
              onPressed: (index) {
                setState(() {
                  selectedDifficulty = ['Facile', 'Moyen', 'Difficile'][index];
                });
              },
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Facile'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Moyen'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Difficile'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              _getDifficultyDescription(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Mode de jeu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ToggleButtons(
              isSelected: [
                selectedMode == '3 vies',
                selectedMode == 'Illimité',
              ],
              onPressed: (index) {
                setState(() {
                  selectedMode = ['3 vies', 'Illimité'][index];
                });
              },
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('3 vies'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Illimité'),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => GameScreenCitiesFr(
                          difficulty: selectedDifficulty,
                          mode: selectedMode,
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text(
                'Commencer la partie',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyDescription() {
    switch (selectedDifficulty) {
      case 'Facile':
        return 'Villes principales et préfectures (plus de 100 000 habitants)';
      case 'Moyen':
        return 'Villes moyennes et sous-préfectures (plus de 20 000 habitants)';
      case 'Difficile':
        return 'Toutes les villes françaises';
      default:
        return '';
    }
  }
}
