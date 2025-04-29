import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../utils/map_styles.dart';


class ReusableMap extends StatefulWidget {
  final MapController mapController;
  final LatLng center;
  final double zoom;
  final List<Marker> markers;
  final Function(MapCamera position, bool hasGesture)? onPositionChanged;
  final bool showZoomControls;

  const ReusableMap({
    super.key,
    required this.mapController,
    required this.center,
    required this.zoom,
    this.markers = const [],
    this.onPositionChanged,
    this.showZoomControls = true,
  });

  @override
  State<ReusableMap> createState() => _ReusableMapState();
}

class _ReusableMapState extends State<ReusableMap> {
  late double _currentZoom;
  late LatLng _currentCenter;

  @override
  void initState() {
    super.initState();
    _currentZoom = widget.zoom;
    _currentCenter = widget.center;
  }

  @override
  void didUpdateWidget(ReusableMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.zoom != widget.zoom || oldWidget.center != widget.center) {
      _currentZoom = widget.zoom;
      _currentCenter = widget.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: widget.mapController,
          options: MapOptions(
            initialCenter: widget.center,
            initialZoom: widget.zoom,
            minZoom: 2.0,
            maxZoom: 18.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
            onPositionChanged: (position, hasGesture) {
              _currentZoom = position.zoom;
              _currentCenter = position.center;

              if (widget.onPositionChanged != null) {
                widget.onPositionChanged!(position, hasGesture);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.georush.app',
              tileDisplay: const TileDisplay.fadeIn(),
              additionalOptions: const {
                'attribution': '© OpenStreetMap contributors',
              },
            ),
            if (widget.markers.isNotEmpty) MarkerLayer(markers: widget.markers),
          ],
        ),
        if (widget.showZoomControls)
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'compass',
                  mini: true,
                  child: const Icon(Icons.compass_calibration_outlined),
                  onPressed: () {
                    widget.mapController.rotate(0);
                    // widget.mapController.move(LatLng(20, 0), 3.0);
                    // setState(() {
                    //   _currentZoom = 3.0;
                    //   _currentCenter = LatLng(20, 0);
                    // });
                  },
                ),
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  mini: true,
                  child: const Icon(Icons.add),
                  onPressed: () {
                    final double newZoom = _currentZoom + 1.0;
                    widget.mapController.move(_currentCenter, newZoom);
                  },
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  mini: true,
                  child: const Icon(Icons.remove),
                  onPressed: () {
                    final double newZoom =
                        _currentZoom - 1.0 < 2.0 ? 2.0 : _currentZoom - 1.0;
                    widget.mapController.move(_currentCenter, newZoom);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
