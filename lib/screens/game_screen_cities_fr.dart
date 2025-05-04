import 'package:flutter/material.dart';
import 'package:georush/widgets/france_map_widget.dart';

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
  @override
  void initState() {
    super.initState();
    // Initialize game logic and other components here
  }

  @override
  void dispose() {
    // Dispose of any resources here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Screen - Cities (FR)')),
      body: Stack(children: [FranceMap(mapController: mapController)]),
    );
  }
}
