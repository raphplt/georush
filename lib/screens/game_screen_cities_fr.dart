import 'package:flutter/material.dart';

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

class _GameScreenCitiesFrState extends State<GameScreenCitiesFr> {}
