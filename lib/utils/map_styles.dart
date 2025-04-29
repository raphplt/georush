import 'package:flutter_map/flutter_map.dart';

class MapStyles {
  // Style minimaliste sans labels de villes/pays (Stamen Toner Light)
  static TileLayer minimalistNoLabels() {
    return TileLayer(
      urlTemplate:
          'https://stamen-tiles.a.ssl.fastly.net/toner-lite/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.georush.app',
      tileDisplay: const TileDisplay.fadeIn(),
      additionalOptions: const {
        'attribution':
            'Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL',
      },
    );
  }

  // Style encore plus minimaliste (Stamen Toner Background)
  static TileLayer ultraMinimalist() {
    return TileLayer(
      urlTemplate:
          'https://stamen-tiles.a.ssl.fastly.net/toner-background/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.georush.app',
      tileDisplay: const TileDisplay.fadeIn(),
      additionalOptions: const {
        'attribution':
            'Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL',
      },
    );
  }

  // Style aquarelle artistique (Stamen Watercolor)
  static TileLayer watercolor() {
    return TileLayer(
      urlTemplate:
          'https://stamen-tiles.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.jpg',
      userAgentPackageName: 'com.georush.app',
      tileDisplay: const TileDisplay.fadeIn(),
      additionalOptions: const {
        'attribution':
            'Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL',
      },
    );
  }

  // Style terrain avec moins de labels (OpenTopoMap)
  static TileLayer terrain() {
    return TileLayer(
      urlTemplate: 'https://tile.opentopomap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.georush.app',
      tileDisplay: const TileDisplay.fadeIn(),
      additionalOptions: const {
        'attribution':
            'Map data: © OpenStreetMap contributors, SRTM | Map style: © OpenTopoMap (CC-BY-SA)',
      },
    );
  }

  // Style sombre (CartoDB Dark Matter)
  static TileLayer darkMode() {
    return TileLayer(
      urlTemplate:
          'https://cartodb-basemaps-a.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.georush.app',
      tileDisplay: const TileDisplay.fadeIn(),
      additionalOptions: const {
        'attribution': '© CARTO © OpenStreetMap contributors',
      },
    );
  }

  // Style standard OpenStreetMap (pour référence)
  static TileLayer standard() {
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.georush.app',
      tileDisplay: const TileDisplay.fadeIn(),
      additionalOptions: const {'attribution': '© OpenStreetMap contributors'},
    );
  }
}
