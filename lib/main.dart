import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(GeoRushApp());
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
