import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'qr_scanner_screen.dart';

class FinishScreen extends StatefulWidget {
  const FinishScreen({super.key});

  @override
  State<FinishScreen> createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
  final TextEditingController _learnedTodayController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  String? _scannedQrResult;

  @override
  void dispose() {
    _learnedTodayController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<Position?> _getCurrentPosition() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied.');
      return null;
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _saveFinishClassToLocal({
    required String learnedToday,
    required String feedback,
    required String location,
    required String timestamp,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('finish_learnedToday', learnedToday);
    await prefs.setString('finish_feedback', feedback);
    await prefs.setString('finish_location', location);
    await prefs.setString('finish_timestamp', timestamp);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finish Class'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'After Class Reflection',
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Capture what you learned today and leave short feedback before closing the class session.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _learnedTodayController,
                      decoration: const InputDecoration(
                        labelText: 'What did you learn today?',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _feedbackController,
                      decoration: const InputDecoration(
                        labelText: 'Feedback about the class or instructor',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final String? result = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QrScannerScreen(),
                          ),
                        );

                        if (result != null && mounted) {
                          setState(() {
                            _scannedQrResult = result;
                          });
                        }
                      },
                      child: const Text('Scan QR Code'),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7FD),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFD4ECF7)),
                      ),
                      child: Text(
                        _scannedQrResult == null
                            ? 'Scanned result: No QR code scanned yet'
                            : 'Scanned result: $_scannedQrResult',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        final String learnedToday = _learnedTodayController.text;
                        final String feedback = _feedbackController.text;
                        final String timestamp = DateTime.now().toIso8601String();
                        final Position? position = await _getCurrentPosition();

                        String location = 'unavailable';
                        if (position != null) {
                          location = '${position.latitude},${position.longitude}';
                        }

                        await _saveFinishClassToLocal(
                          learnedToday: learnedToday,
                          feedback: feedback,
                          location: location,
                          timestamp: timestamp,
                        );

                        debugPrint('Learned today: $learnedToday');
                        debugPrint('Class feedback: $feedback');
                        debugPrint('Scanned QR result: ${_scannedQrResult ?? 'none'}');
                        debugPrint('Location: $location');
                        debugPrint('Finish timestamp: $timestamp');
                        debugPrint('Finish class data saved locally with SharedPreferences.');
                      },
                      child: const Text('Finish Class'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
