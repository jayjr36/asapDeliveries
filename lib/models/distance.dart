import 'dart:math' show sin, cos, sqrt, atan2, pi;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Location Distance Calculator',
      home: DistanceCalculator(),
    );
  }
}

class DistanceCalculator extends StatefulWidget {
  const DistanceCalculator({super.key});

  @override
  _DistanceCalculatorState createState() => _DistanceCalculatorState();
}

class _DistanceCalculatorState extends State<DistanceCalculator> {
  final String destinationLatitude = '-6.817252';
  final String destinationLongitude = '39.277101';
  Position? _currentPosition;
  double? _distance;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      _calculateDistance();
    } catch (e) {
      print(e);
    }
  }

  double _haversineDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const int radiusOfEarth = 6371;
    double dLat = (lat2 - lat1) * (pi / 180);
    double dLon = (lon2 - lon1) * (pi / 180);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radiusOfEarth * c;
  }

  void _calculateDistance() {
    if (_currentPosition == null) return;

    double currentLatitude = _currentPosition!.latitude;
    double currentLongitude = _currentPosition!.longitude;
    double destinationLat = double.parse(destinationLatitude);
    double destinationLon = double.parse(destinationLongitude);

    _distance = _haversineDistance(
      currentLatitude,
      currentLongitude,
      destinationLat,
      destinationLon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Distance Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your Current Location:',
              style: TextStyle(fontSize: 18),
            ),
            if (_currentPosition != null)
              Text(
                'Latitude: ${_currentPosition!.latitude}\nLongitude: ${_currentPosition!.longitude}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            if (_distance != null)
              Text(
                'Distance to Destination: ${_distance!.toStringAsFixed(2)} kilometers',
                style: const TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}