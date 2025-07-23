import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import '../../logic/media_controller.dart';
import '../../data/models/media_item.dart';

class MediaScannerScreen extends StatelessWidget {
  const MediaScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MediaController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Media Scanner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Barcode scannen'),
              onPressed: () async {
                final barcode = await FlutterBarcodeScanner.scanBarcode(
                  "#ff6666",
                  "Abbrechen",
                  true,
                  ScanMode.BARCODE,
                );

                if (barcode != '-1') {
                  await context.read<MediaController>().scanBarcode(barcode);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Barcode $barcode gescannt')),
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // Desktop-Testfeld
            TextField(
              decoration: const InputDecoration(
                labelText: 'Barcode manuell eingeben (nur für Desktop)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (code) async {
                await context.read<MediaController>().scanBarcode(code);
              },
            ),
            const SizedBox(height: 24),

            controller.isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: controller.items.isEmpty
                        ? const Text('Keine Medien gescannt.')
                        : ListView.builder(
                            itemCount: controller.items.length,
                            itemBuilder: (context, index) {
                              final item = controller.items[index];
                              return ListTile(
                                leading: const Icon(Icons.album),
                                title: Text(item.name ?? 'Unbekannt'),
                                subtitle: Text('GTIN: ${item.gtin}'),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
