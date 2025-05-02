import 'package:flutter/material.dart';
import 'game_screen.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({super.key});

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  String selectedDifficulty = 'Facile';
  String selectedMode = '3 vies';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Préparer la partie')),
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
                        (context) => GameScreen(
                          difficulty: selectedDifficulty,
                          mode: selectedMode,
                        ),
                  ),
                );
              },
              child: Text('Commencer la partie'),
            ),
          ],
        ),
      ),
    );
  }
}
