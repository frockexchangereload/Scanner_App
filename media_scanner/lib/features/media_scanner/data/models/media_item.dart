class MediaItem {
  final String title;
  final String barcode;
  final String? type; // DVD, CD
  final String? origin; // Hersteller, Label
  final DateTime addedAt;

  MediaItem({
    required this.title,
    required this.barcode,
    this.type,
    this.origin,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  List<String> toCsvRow() => [
    title,
    barcode,
    type ?? '',
    origin ?? '',
    addedAt.toIso8601String(),
  ];
}
