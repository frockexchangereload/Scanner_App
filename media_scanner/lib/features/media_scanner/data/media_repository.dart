import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/media_item.dart';

class MediaRepository {
  static const String _baseUrl = 'https://opengtindb.org/api.php';
  static const String _queryId =
      'demo'; // Offiziell erlaubt für nicht-authentifizierte Anfragen

  Future<MediaItem?> fetchMediaItem(String barcode) async {
    final uri = Uri.parse('$_baseUrl?ean=$barcode&cmd=query&queryid=$_queryId');

    try {
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        print('HTTP Fehler: ${response.statusCode}');
        return null;
      }

      final lines = const LineSplitter().convert(response.body);

      if (lines.isEmpty || lines[0].startsWith('error')) {
        print('Kein Eintrag gefunden oder Fehler: ${lines[0]}');
        return null;
      }

      String? title;
      String? manufacturer;

      for (final line in lines) {
        if (line.startsWith('1 Titel:')) {
          title = line.replaceFirst('1 Titel:', '').trim();
        }
        if (line.startsWith('2 Hersteller:')) {
          manufacturer = line.replaceFirst('2 Hersteller:', '').trim();
        }
      }

      if (title == null) {
        print('Kein Titel in Antwort gefunden.');
        return null;
      }

      return MediaItem(
        title: title,
        barcode: barcode,
        type: _inferMediaTypeFromTitle(title),
        origin: manufacturer,
      );
    } catch (e) {
      print('Fehler beim Abrufen von OpenGTINDB: $e');
      return null;
    }
  }

  Future<MediaItem?> fetchItemByBarcode(String barcode) {
    return fetchMediaItem(barcode);
  }

  /// Einfache Heuristik zur Typbestimmung
  String? _inferMediaTypeFromTitle(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('dvd')) return 'DVD';
    if (lower.contains('cd')) return 'CD';
    return null;
  }
}
