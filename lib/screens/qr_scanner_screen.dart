import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_hasScanned) {
            return;
          }

          if (capture.barcodes.isEmpty) {
            return;
          }

          final Barcode barcode = capture.barcodes.first;
          final String? value = barcode.rawValue;

          if (value != null && value.isNotEmpty) {
            _hasScanned = true;
            Navigator.pop(context, value);
          }
        },
      ),
    );
  }
}
