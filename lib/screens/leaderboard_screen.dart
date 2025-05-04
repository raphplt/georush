import 'package:flutter/material.dart';
import 'package:georush/services/game_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late Future<Map<String, dynamic>> _gameDataFuture;

  @override
  void initState() {
    super.initState();
    _gameDataFuture = GameService.loadGameData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tableau des scores')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _gameDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildScoreTile('Pays', data['countryScore']),
              _buildScoreTile('Villes', data['cityScore']),
              _buildScoreTile('Drapeaux', data['flagScore']),
              _buildScoreTile('Monuments', data['monumentScore']),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScoreTile(String title, int score) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(score.toString(), style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
