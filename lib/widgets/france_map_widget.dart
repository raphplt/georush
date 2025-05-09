import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FranceMap extends StatelessWidget {
  final MapController mapController;
  final List<Marker> markers;
  final Function(MapCamera position, bool hasGesture)? onPositionChanged;

  const FranceMap({
    super.key,
    required this.mapController,
    this.markers = const [],
    this.onPositionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(46.603354, 1.888334),
        initialZoom: 6.0,
        minZoom: 5.0,
        maxZoom: 12.0,
        maxBounds: LatLngBounds(
          LatLng(41.0, -5.5), // Sud-Ouest
          LatLng(51.5, 9.5), // Nord-Est
        ),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onPositionChanged: onPositionChanged,
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.georush.app',
        ),
        if (markers.isNotEmpty) MarkerLayer(markers: markers),
      ],
    );
  }
}
