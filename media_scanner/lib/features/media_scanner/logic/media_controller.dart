import 'package:flutter/material.dart';
import '../data/media_repository.dart';
import '../data/models/media_item.dart';

class MediaController with ChangeNotifier {
  final List<MediaItem> _items = [];
  final MediaRepository _repository = MediaRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<MediaItem> get items => List.unmodifiable(_items);

  Future<void> scanBarcode(String barcode) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.fetchItemByBarcode(barcode);
      if (result != null) {
        _items.add(result);
      } else {
        // Fehlerbehandlung folgt evtl. separat
        debugPrint('Kein Ergebnis für Barcode: $barcode');
      }
    } catch (e) {
      debugPrint('Fehler beim Scannen: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
