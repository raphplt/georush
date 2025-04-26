import 'package:flutter/material.dart';

/// Widget pour afficher un trophée (débloqué ou verrouillé)
class TrophyWidget extends StatelessWidget {
  final bool unlocked; // true = trophée débloqué, false = encore verrouillé

  const TrophyWidget({
    Key? key,
    this.unlocked = false, // Par défaut, le trophée est verrouillé
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: unlocked ? Colors.amber.shade400 : Colors.grey.shade300,
          shape: BoxShape.circle,
          border: Border.all(
            color: unlocked ? Colors.amber : Colors.grey,
            width: 2,
          ),
        ),
        child: Icon(
          unlocked
              ? Icons.emoji_events
              : Icons.lock, // Coupe pour trophée, cadenas sinon
          color: unlocked ? Colors.white : Colors.grey.shade700,
          size: 30,
        ),
      ),
    );
  }
}
