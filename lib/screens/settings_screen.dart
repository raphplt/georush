import 'package:flutter/material.dart';
import '../services/player_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String playerName = '';
  int playerScore = 0;

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  // Utilisation du service pour charger les données du joueur
  Future<void> _loadPlayerData() async {
    final playerData = await PlayerService.loadPlayerData();

    setState(() {
      playerName = playerData['name'];
      playerScore = playerData['score'];
    });
  }

  // Ouvrir la boîte de dialogue pour changer le nom
  void _changePlayerName() {
    PlayerService.showNameDialog(context, (String newName) {
      setState(() {
        playerName = newName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paramètres')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil du joueur
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nom du joueur'),
                            Text(
                              playerName.isNotEmpty ? playerName : 'Non défini',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: _changePlayerName,
                          child: Text('Modifier'),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('Score total: $playerScore'),
                  ],
                ),
              ),
            ),

            // Vous pouvez ajouter d'autres paramètres ici
            // Par exemple: réinitialiser les progrès, changer les paramètres sonores, etc.
          ],
        ),
      ),
    );
  }
}
