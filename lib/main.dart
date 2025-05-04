import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/audio_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AudioService(),
      child: const GeoRushApp(),
    ),
  );
}

class GeoRushApp extends StatelessWidget {
  const GeoRushApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Rush',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashScreen(),
    );
  }
}
