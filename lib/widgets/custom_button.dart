import 'package:flutter/material.dart';

/// Bouton customisable utilisé sur l'écran d'accueil et dans d'autres parties du jeu
class CustomButton extends StatelessWidget {
  final String text; // Texte du bouton
  final IconData icon; // Icône affiché avant le texte
  final VoidCallback onPressed; // Action au clic
  final Color color; // Couleur de fond du bouton (optionnel)

  const CustomButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.color = Colors.blue, // Valeur par défaut : bleu
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min, // Garde le bouton compact
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
        ],
      ),
    );
  }
}
