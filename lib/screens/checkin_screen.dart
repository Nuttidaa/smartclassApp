import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'qr_scanner_screen.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final TextEditingController _previousTopicController = TextEditingController();
  final TextEditingController _expectedTopicController = TextEditingController();
  double _moodValue = 3;
  String? _scannedQrResult;

  @override
  void dispose() {
    _previousTopicController.dispose();
    _expectedTopicController.dispose();
    super.dispose();
  }

  String _moodLabel(double value) {
    switch (value.toInt()) {
      case 1:
        return '1 = Very Negative 😡';
      case 2:
        return '2 = Negative 🙁';
      case 3:
        return '3 = Neutral 😐';
      case 4:
        return '4 = Positive 🙂';
      case 5:
        return '5 = Very Positive 😄';
      default:
        return '3 = Neutral 😐';
    }
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

  Future<void> _saveCheckInToLocal({
    required String previousTopic,
    required String expectedTopic,
    required int mood,
    required double? latitude,
    required double? longitude,
    required String timestamp,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('checkin_previousTopic', previousTopic);
    await prefs.setString('checkin_expectedTopic', expectedTopic);
    await prefs.setInt('checkin_mood', mood);
    await prefs.setString('checkin_timestamp', timestamp);

    if (latitude != null && longitude != null) {
      await prefs.setDouble('checkin_latitude', latitude);
      await prefs.setDouble('checkin_longitude', longitude);
    } else {
      await prefs.remove('checkin_latitude');
      await prefs.remove('checkin_longitude');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in'),
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
                      'Before Class Check-in',
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share what you remember, what you expect today, and how you feel before class starts.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _previousTopicController,
                      decoration: const InputDecoration(
                        labelText: 'What topic was covered in the previous class',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _expectedTopicController,
                      decoration: const InputDecoration(
                        labelText: 'What topic do you expect to learn today',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _moodLabel(_moodValue),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      min: 1,
                      max: 5,
                      divisions: 4,
                      value: _moodValue,
                      label: _moodValue.toInt().toString(),
                      onChanged: (value) {
                        setState(() {
                          _moodValue = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        final String previousTopic = _previousTopicController.text;
                        final String expectedTopic = _expectedTopicController.text;
                        final int mood = _moodValue.toInt();

                        debugPrint('Previous topic: $previousTopic');
                        debugPrint('Expected topic: $expectedTopic');
                        debugPrint('Mood value: $mood');
                        debugPrint('Mood label: ${_moodLabel(_moodValue)}');
                        debugPrint('Scanned QR result: ${_scannedQrResult ?? 'none'}');

                        final Position? position = await _getCurrentPosition();
                        final String timestamp = DateTime.now().toIso8601String();
                        final double? latitude = position?.latitude;
                        final double? longitude = position?.longitude;

                        await _saveCheckInToLocal(
                          previousTopic: previousTopic,
                          expectedTopic: expectedTopic,
                          mood: mood,
                          latitude: latitude,
                          longitude: longitude,
                          timestamp: timestamp,
                        );

                        debugPrint('Check-in data saved locally with SharedPreferences.');

                        if (position != null) {
                          debugPrint('Latitude: $latitude');
                          debugPrint('Longitude: $longitude');
                          debugPrint('Check-in timestamp: $timestamp');
                        } else {
                          debugPrint('GPS location not available. Timestamp: $timestamp');
                        }
                      },
                      child: const Text('Submit Check-in'),
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
