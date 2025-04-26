import 'package:flutter/material.dart';
import 'package:georush/screens/settings_screen.dart';
import 'game_screen.dart';
import 'discover_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/trophy_widget.dart';
import '../services/player_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String playerName = '';
  int playerScore = 0;

  @override
  void initState() {
    super.initState();
    _initializePlayerData();
  }

  // Initialiser les données du joueur
  Future<void> _initializePlayerData() async {
    final playerData = await PlayerService.loadPlayerData();

    setState(() {
      playerName = playerData['name'];
      playerScore = playerData['score'];
    });

    if (playerName.isEmpty) {
      Future.delayed(Duration.zero, () => _showNameDialog());
    }
  }

  // Afficher la boîte de dialogue pour le nom
  void _showNameDialog() {
    PlayerService.showNameDialog(context, (String name) {
      setState(() {
        playerName = name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec profil et paramètres
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playerName.isNotEmpty
                                  ? playerName
                                  : 'Nom du joueur',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Score: $playerScore',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Section trophées
              Text(
                'Trophées',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TrophyWidget(),
                  TrophyWidget(),
                  TrophyWidget(),
                  TrophyWidget(),
                ],
              ),

              SizedBox(height: 30),

              // Section modes de jeu
              Text(
                'Modes de jeu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    CustomButton(
                      text: "Mode Pays",
                      icon: Icons.public,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameScreen()),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      text: "Mode Drapeaux",
                      icon: Icons.flag,
                      onPressed: () {
                        // TODO : Naviguer vers mode drapeaux
                      },
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      text: "Mode Capitales",
                      icon: Icons.location_city,
                      onPressed: () {
                        // TODO : Naviguer vers mode capitales
                      },
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      text: "Mode découverte",
                      icon: Icons.map_rounded,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverScreen(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
