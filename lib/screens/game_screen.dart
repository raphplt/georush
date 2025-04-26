import 'package:flutter/material.dart';

/// Ecran principal de jeu où l'utilisateur répond à des questions de géographie
class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0; // Score actuel du joueur
  int timeLeft = 30; // Temps restant pour répondre
  late final List<String> options; // Les choix possibles pour la question
  String correctAnswer =
      'France'; // Bonne réponse (à améliorer plus tard dynamiquement)

  @override
  void initState() {
    super.initState();
    startTimer();
    loadQuestion();
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
      body: SafeArea(
        child: Column(
          children: [
            // Timer en haut
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                value: timeLeft / 30, // Barre qui se vide
                color: Colors.blue,
                backgroundColor: Colors.grey.shade300,
              ),
            ),
            SizedBox(height: 10),
            // Image ou Carte statique
            Expanded(
              child: Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Image / Carte ici",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Liste des réponses
            Padding(
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
    );
  }
}
