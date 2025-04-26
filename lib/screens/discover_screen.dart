import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 3.0;
  LatLng _currentCenter = LatLng(
    20,
    0,
  ); // Position initiale centrée sur le monde

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explorer le monde'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Retour à la vue mondiale
              _mapController.move(
                LatLng(20, 0), // Coordonnées du centre du monde
                3.0, // Zoom initial
              );
              setState(() {
                _currentZoom = 3.0;
                _currentCenter = LatLng(20, 0);
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: _currentZoom,
              minZoom:
                  2.0, // Limiter le dézoom pour éviter la distorsion excessive
              maxZoom: 18.0,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all,
              ),
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() {
                    _currentZoom = position.zoom ?? _currentZoom;
                    _currentCenter = position.center ?? _currentCenter;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.georush.app',
                // Attribution requise pour OpenStreetMap
                tileDisplay: const TileDisplay.fadeIn(),
                additionalOptions: const {
                  'attribution': '© OpenStreetMap contributors',
                },
              ),
              // Vous pouvez ajouter des marqueurs pour les pays ou régions d'intérêt
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(48.8566, 2.3522), // Paris
                    width: 80,
                    height: 80,
                    child: GestureDetector(
                      onTap: () {
                        _showCountryInfo('France', 'Paris');
                      },
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(51.5074, -0.1278), // Londres
                    width: 80,
                    height: 80,
                    child: GestureDetector(
                      onTap: () {
                        _showCountryInfo('Royaume-Uni', 'Londres');
                      },
                      child: Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ),
                  // Vous pouvez ajouter d'autres marqueurs pour d'autres pays
                ],
              ),
            ],
          ),

          // Contrôles de zoom personnalisés
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  mini: true,
                  child: Icon(Icons.add),
                  onPressed: () {
                    final double newZoom = _currentZoom + 1.0;
                    _mapController.move(
                      _currentCenter, // premier argument: center (position)
                      newZoom, // deuxième argument: zoom
                    );
                    setState(() {
                      _currentZoom = newZoom;
                    });
                  },
                ),
                SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  mini: true,
                  child: Icon(Icons.remove),
                  onPressed: () {
                    final double newZoom =
                        _currentZoom - 1.0 < 2.0 ? 2.0 : _currentZoom - 1.0;
                    _mapController.move(_currentCenter, newZoom);
                    setState(() {
                      _currentZoom = newZoom;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCountryInfo(String country, String capital) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(country),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Capitale: $capital'),
              SizedBox(height: 8),
              Text('Touchez pour en savoir plus sur ce pays'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('En savoir plus'),
              onPressed: () {
                Navigator.of(context).pop();
                // Ici vous pourriez naviguer vers un écran détaillé sur le pays
              },
            ),
          ],
        );
      },
    );
  }
}
