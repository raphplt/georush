import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/map_widget.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 3.0;
  LatLng _currentCenter = LatLng(20, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explorer le monde'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
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
          ReusableMap(
            mapController: _mapController,
            center: _currentCenter,
            zoom: _currentZoom,
            showZoomControls: true,
            // markers: [
            //   Marker(
            //     point: LatLng(48.8566, 2.3522), // Paris
            //     width: 80,
            //     height: 80,
            //     child: GestureDetector(
            //       onTap: () {
            //         _showCountryInfo('France', 'Paris');
            //       },
            //       child: Icon(Icons.location_on, color: Colors.red, size: 30),
            //     ),
            //   ),
            // ],
            onPositionChanged: (position, hasGesture) {
              if (hasGesture) {
                setState(() {
                  _currentZoom = position.zoom ?? _currentZoom;
                  _currentCenter = position.center ?? _currentCenter;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
