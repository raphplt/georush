import 'package:flutter/material.dart';
import 'package:georush/helpers/map_helper_fr.dart';
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
  late MapHelperFr mapHelperFr;
  @override
  void initState() {
    super.initState();
    mapHelperFr = MapHelperFr();
  }



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Screen - Cities (FR)')),
      body: Stack(
        children: [FranceMap(mapController: mapHelperFr.mapController)],
      ),
    );
  }
}
