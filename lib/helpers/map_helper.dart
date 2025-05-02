import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapHelper {
  final MapController mapController = MapController();

  final LatLng initialPosition = LatLng(46.603354, 1.888334);

  List<Polygon> polygonsFromGeoJson(Map<String, dynamic> geometry) {
    final type = geometry['type'];
    List<Polygon> polygons = [];

    if (type == 'Polygon') {
      polygons.add(_createPolygonFromCoordinates(geometry['coordinates'][0]));
    } else if (type == 'MultiPolygon') {
      final multiPolygon = geometry['coordinates'] as List;
      for (var polygon in multiPolygon) {
        polygons.add(_createPolygonFromCoordinates(polygon[0]));
      }
    }

    return polygons;
  }

  Polygon _createPolygonFromCoordinates(List coordinates) {
    List<LatLng> points = [];

    for (var coord in coordinates) {
      final double lng = coord[0];
      final double lat = coord[1];
      points.add(LatLng(lat, lng));
    }

    return Polygon(
      points: points,
      color: Colors.blue.withOpacity(0.5),
      borderColor: Colors.blue,
      borderStrokeWidth: 2.0,
    );
  }

  void centerOnLocation(LatLng location, double zoom) {
    mapController.move(location, zoom);
  }

  void dispose() {
    mapController.dispose();
  }
}
