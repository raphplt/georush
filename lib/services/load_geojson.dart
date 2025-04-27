import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:developer';

Future<Map<String, dynamic>> loadGeoJson() async {
  try {
    log('Chargement du fichier GeoJSON...');
    final String filePath = 'assets/countries.geojson';

    final String jsonString = await rootBundle.loadString(filePath);

    if (jsonString.isEmpty) {
      log('Fichier GeoJSON vide');
      return {'features': []};
    }

    log('Taille du fichier GeoJSON: ${jsonString.length} caractères');
    final Map<String, dynamic> geoJsonData = json.decode(jsonString);
    log(
      'GeoJSON chargé avec succès. Nombre de features: ${(geoJsonData['features'] as List?)?.length ?? 0}',
    );
    return geoJsonData;
  } catch (e, stackTrace) {
    log('Erreur lors du chargement du GeoJSON: $e');
    log('Stack trace: $stackTrace');
    return {'features': []};
  }
}
