import 'package:flutter/material.dart';
import 'storage_service.dart';

class PlayerService {
  static final PlayerService _instance = PlayerService._internal();

  factory PlayerService() {
    return _instance;
  }

  PlayerService._internal();

  static Future<Map<String, dynamic>> loadPlayerData() async {
    final name = await StorageService.getPlayerName();
    final score = await StorageService.getPlayerScore() ?? 0;

    return {'name': name ?? '', 'score': score};
  }

  static void showNameDialog(BuildContext context, Function(String) onNameSet) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bienvenue !'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'Entre ton prénom'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final enteredName = nameController.text.trim();
                if (enteredName.isNotEmpty) {
                  await StorageService.savePlayerName(enteredName);
                  onNameSet(enteredName);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }
}
