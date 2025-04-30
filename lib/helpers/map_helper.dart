import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapHelper {
  final MapController mapController = MapController();

  // TODO: à modifier
  final LatLng initialPosition = LatLng(46.603354, 1.888334);

  // Create a marker for a location
  Marker createLocationMarker(LatLng position) {
    return Marker(
      point: position,
      width: 40,
      height: 40,
      child: Icon(Icons.location_on, color: Colors.red, size: 40),
    );
  }

  // Center map on a specific location
  void centerOnLocation(LatLng location, double zoom) {
    mapController.move(location, zoom);
  }

  void dispose() {
    mapController.dispose();
  }
}
