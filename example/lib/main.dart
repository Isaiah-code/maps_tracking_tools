import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:maps_tracking_toolbox/maps_tracking_toolbox.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps Tracking Toolbox Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  final mapsTools = const MapsTrackingTools();
  String result = 'Tap a button to see results';
  bool isLoading = false;

  // Example coordinates
  final accraLocation = const LatLng(5.6037, -0.1870); // Accra, Ghana
  final kumasiLocation = const LatLng(6.6885, -1.6244); // Kumasi, Ghana

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Maps Tracking Tools Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Result card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Result:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      Text(
                        result,
                        style: const TextStyle(fontSize: 16),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Example 1: Calculate distance between two points
            ElevatedButton.icon(
              onPressed: _calculateDistance,
              icon: const Icon(Icons.straighten),
              label: const Text('Calculate Distance (Accra → Kumasi)'),
            ),
            const SizedBox(height: 12),

            // Example 2: Convert degrees to radians
            ElevatedButton.icon(
              onPressed: _convertDegToRad,
              icon: const Icon(Icons.rotate_right),
              label: const Text('Convert 180° to Radians'),
            ),
            const SizedBox(height: 12),

            // Example 3: Normalize heading
            ElevatedButton.icon(
              onPressed: _normalizeHeading,
              icon: const Icon(Icons.explore),
              label: const Text('Normalize Heading (-90°)'),
            ),
            const SizedBox(height: 12),

            // Example 4: Get current location distance
            ElevatedButton.icon(
              onPressed: _getCurrentLocationDistance,
              icon: const Icon(Icons.my_location),
              label: const Text('Distance from Current Location'),
            ),
            const SizedBox(height: 12),

            // Example 5: Test route deviation detection
            ElevatedButton.icon(
              onPressed: _testRouteDeviation,
              icon: const Icon(Icons.route),
              label: const Text('Test Route Deviation Detection'),
            ),
            const SizedBox(height: 12),

            // Example 6: Calculate distance to step
            ElevatedButton.icon(
              onPressed: _calculateStepDistance,
              icon: const Icon(Icons.directions),
              label: const Text('Distance to Navigation Step'),
            ),
            const SizedBox(height: 24),

            // Info section
            const Card(
              color: Colors.lightBlue,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'About This Example',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This example demonstrates the core features of the Maps Tracking Tools package:\n\n'
                      '• Distance calculations using Haversine formula\n'
                      '• Degree to radian conversion\n'
                      '• Heading normalization\n'
                      '• Location-based distance calculations\n'
                      '• Route deviation detection\n'
                      '• Navigation step distance tracking',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateDistance() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final distance = mapsTools.convertToKM(
        pickup: accraLocation,
        dropOff: kumasiLocation,
      );

      setState(() {
        result = 'Distance from Accra to Kumasi:\n$distance km\n\n'
            'Coordinates:\n'
            'Accra: (${accraLocation.latitude}, ${accraLocation.longitude})\n'
            'Kumasi: (${kumasiLocation.latitude}, ${kumasiLocation.longitude})';
        isLoading = false;
      });
    });
  }

  void _convertDegToRad() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      final radians = mapsTools.degToRad(degree: 180);

      setState(() {
        result = '180 degrees in radians:\n${radians.toStringAsFixed(5)}\n\n'
            'This is approximately π (pi)';
        isLoading = false;
      });
    });
  }

  void _normalizeHeading() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      final normalized = mapsTools.returnHeading(-90);

      setState(() {
        result = 'Normalized heading:\n'
            'Input: -90°\n'
            'Output: $normalized°\n\n'
            'Negative headings are converted to positive by adding 360';
        isLoading = false;
      });
    });
  }

  Future<void> _getCurrentLocationDistance() async {
    setState(() {
      isLoading = true;
      result = 'Getting your location...';
    });

    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            result = 'Location permission denied.\n'
                'Please enable location permissions to use this feature.';
            isLoading = false;
          });
          return;
        }
      }

      // Get current location
      final Location location = Location();
      final currentLocation = await location.getLocation();

      final distance = await mapsTools.getDistanceFromLatLonInKm(
        currentLocation: currentLocation,
        endPoint: kumasiLocation,
      );

      setState(() {
        result = 'Distance from your location to Kumasi:\n'
            '$distance km\n\n'
            'Your location:\n'
            'Lat: ${currentLocation.latitude?.toStringAsFixed(4)}\n'
            'Lng: ${currentLocation.longitude?.toStringAsFixed(4)}';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        result = 'Error getting location:\n$e\n\n'
            'Make sure location services are enabled.';
        isLoading = false;
      });
    }
  }

  Future<void> _testRouteDeviation() async {
    setState(() {
      isLoading = true;
    });

    // Simulate a route polyline
    final polyline = [
      const LatLng(5.6000, -0.1800),
      const LatLng(5.6037, -0.1870),
      const LatLng(5.6100, -0.1900),
      const LatLng(5.6150, -0.1950),
    ];

    // Simulate rider location on route
    const position = LatLng(5.6037, -0.1870);

    final directionInfo = await mapsTools.reCallDirectionsApi(
      context: context,
      position: position,
      polyCoordinates: List.from(polyline),
    );

    setState(() {
      result = 'Route Deviation Test:\n\n'
          'Original polyline points: ${polyline.length}\n'
          'Updated polyline points: ${directionInfo.polyCoordinates.length}\n'
          'Should recalculate route: ${directionInfo.recalculate ? "Yes" : "No"}\n\n'
          'Rider is ${directionInfo.recalculate ? "OFF" : "ON"} the planned route.\n\n'
          'Deviation threshold: 0.05 km (50 meters)';
      isLoading = false;
    });
  }

  Future<void> _calculateStepDistance() async {
    setState(() {
      isLoading = true;
    });

    // Create a sample navigation step
    final step = Steps(
      distance: Distance(text: '1.5 km', value: 1500),
      duration: Distance(text: '5 mins', value: 300),
      startLocation: Northeast(lat: 5.6037, lng: -0.1870),
      endLocation: Northeast(lat: 5.6150, lng: -0.1950),
      htmlInstructions: 'Turn <b>right</b> onto Ring Road',
      polyline: Polylines(points: 'encoded_polyline_example'),
      travelMode: 'DRIVING',
      maneuver: 'turn-right',
    );

    // Simulate rider location
    final riderLocation = Position(
      latitude: 5.6037,
      longitude: -0.1870,
      timestamp: DateTime.now(),
      accuracy: 10,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

    final distance = mapsTools.updateDistanceOnActiveStep(
      currentStep: step,
      riderLocation: riderLocation,
    );

    setState(() {
      result = 'Navigation Step Distance:\n\n'
          'Instruction: ${step.htmlInstructions?.replaceAll(RegExp(r'<[^>]*>'), '')}\n'
          'Maneuver: ${step.maneuver}\n'
          'Travel Mode: ${step.travelMode}\n\n'
          'Distance to step end: $distance km\n'
          'Step total distance: ${step.distance?.text}\n'
          'Estimated duration: ${step.duration?.text}';
      isLoading = false;
    });
  }
}
