// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/media_scanner/logic/media_controller.dart';
import 'features/media_scanner/presentation/media_scanner_screen.dart';

void main() {
  runApp(const MediaScannerApp());
}

class MediaScannerApp extends StatelessWidget {
  const MediaScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MediaController(),
      child: MaterialApp(
        title: 'Media Scanner',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: const MediaScannerScreen(),
      ),
    );
  }
}
