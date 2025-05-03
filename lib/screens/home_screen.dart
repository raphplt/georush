import 'package:flutter/material.dart';
import 'package:georush/screens/settings_screen.dart';
import 'package:georush/screens/start_game.dart';
import 'package:video_player/video_player.dart';
import 'discover_screen.dart';
import '../services/player_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String playerName = '';
  int playerScore = 0;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _initializePlayerData();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoController =
        VideoPlayerController.asset('assets/images/home_video.mp4')
          ..setLooping(true)
          ..initialize().then((_) {
            if (mounted) {
              setState(() {});
            }
            _videoController.play();
          });
  }
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

  void _showNameDialog() {
    PlayerService.showNameDialog(context, (String name) {
      setState(() {
        playerName = name;
      });
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _videoController.value.isInitialized
              ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController.value.size.width,
                    height: _videoController.value.size.height,
                    child: VideoPlayer(_videoController),
                  ),
                ),
              )
              : Container(color: Colors.black),
          Container(color: Colors.black.withOpacity(0.2)),
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                    color: Colors.white
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Score: $playerScore',
                              style: TextStyle(
                                fontSize: 14,
                                    color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                        icon: Icon(Icons.settings, color: Colors.white),
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

                  // Text(
                  //   'Modes de jeu',
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white,
                  //       ),
                  // ),
                  SizedBox(height: 15),

              Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                  children: [
                        _buildGameModeTile(
                          title: "Mode Pays",
                      icon: Icons.public,
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StartGameScreen(),
                              ),
                            );
                          },
                          description:
                              "Testez vos connaissances sur les pays du monde",
                    ),
                        _buildGameModeTile(
                          title: "Mode Drapeaux",
                      icon: Icons.flag,
                          color: Colors.red,
                          onTap: () {
                        // TODO : Naviguer vers mode drapeaux
                      },
                          description: "Reconnaissez les drapeaux des nations",
                    ),
                        _buildGameModeTile(
                          title: "Mode Capitales",
                      icon: Icons.location_city,
                          color: Colors.green,
                          onTap: () {
                        // TODO : Naviguer vers mode capitales
                      },
                          description: "Trouvez les capitales des pays",
                    ),
                        _buildGameModeTile(
                          title: "Mode découverte",
                      icon: Icons.map_rounded,
                          color: Colors.amber,
                          onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverScreen(),
                          ),
                        );
                      },
                          description: "Explorez et apprenez sans pression",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]

      )

    );
  }

  Widget _buildGameModeTile({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String description,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
