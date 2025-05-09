import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapHelperFr {
  final MapController mapController = MapController();

  final LatLng initialPosition = LatLng(46.603354, 1.888334);

  void centerOnLocation(LatLng location, double zoom) {
    mapController.move(location, zoom);
  }

  void dispose() {
    mapController.dispose();
  }
}
