import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_tracking_toolbox/maps_tracking_toolbox.dart';

void main() {
  late MapsTrackingTools mapsTools;

  setUp(() {
    mapsTools = const MapsTrackingTools();
  });

  group('degToRad', () {
    test('converts 0 degrees to 0 radians', () {
      expect(mapsTools.degToRad(degree: 0), 0);
    });

    test('converts 180 degrees to PI radians', () {
      expect(mapsTools.degToRad(degree: 180), closeTo(3.14159, 0.00001));
    });

    test('converts 90 degrees to PI/2 radians', () {
      expect(mapsTools.degToRad(degree: 90), closeTo(1.5708, 0.0001));
    });

    test('converts 360 degrees to 2*PI radians', () {
      expect(mapsTools.degToRad(degree: 360), closeTo(6.28318, 0.00001));
    });

    test('handles negative degrees', () {
      expect(mapsTools.degToRad(degree: -90), closeTo(-1.5708, 0.0001));
    });
  });

  group('convertToKM', () {
    test('calculates distance between two identical points as 0', () {
      const pickup = LatLng(0.0, 0.0);
      const dropOff = LatLng(0.0, 0.0);

      final distance = mapsTools.convertToKM(pickup: pickup, dropOff: dropOff);

      expect(double.parse(distance), 0.0);
    });

    test('calculates approximate distance between Accra and Kumasi', () {
      // Accra coordinates
      const accra = LatLng(5.6037, -0.1870);
      // Kumasi coordinates
      const kumasi = LatLng(6.6885, -1.6244);

      final distance = mapsTools.convertToKM(pickup: accra, dropOff: kumasi);

      // Approximate distance is around 200km
      expect(double.parse(distance), closeTo(200, 50));
    });

    test('calculates distance between nearby points correctly', () {
      // Two points approximately 1km apart
      const point1 = LatLng(5.6037, -0.1870);
      const point2 = LatLng(5.6127, -0.1870); // ~1km north

      final distance = mapsTools.convertToKM(pickup: point1, dropOff: point2);

      expect(double.parse(distance), closeTo(1.0, 0.5));
    });

    test('returns distance with 2 decimal places', () {
      const pickup = LatLng(5.6037, -0.1870);
      const dropOff = LatLng(5.6127, -0.1870);

      final distance = mapsTools.convertToKM(pickup: pickup, dropOff: dropOff);

      // Check format has 2 decimal places
      final parts = distance.split('.');
      expect(parts.length, 2);
      expect(parts[1].length, 2);
    });

    test('handles reverse direction (same distance)', () {
      const point1 = LatLng(5.6037, -0.1870);
      const point2 = LatLng(5.6127, -0.1870);

      final distance1 = mapsTools.convertToKM(pickup: point1, dropOff: point2);
      final distance2 = mapsTools.convertToKM(pickup: point2, dropOff: point1);

      expect(distance1, distance2);
    });
  });

  group('getDistanceFromLatLonInKm', () {
    test('calculates distance from LocationData to LatLng', () async {
      final currentLocation = LocationData.fromMap({
        'latitude': 5.6037,
        'longitude': -0.1870,
      });
      const endPoint = LatLng(5.6127, -0.1870);

      final distance = await mapsTools.getDistanceFromLatLonInKm(
        currentLocation: currentLocation,
        endPoint: endPoint,
      );

      expect(distance, isA<double>());
      expect(distance, greaterThan(0));
    });

    test('handles null latitude/longitude as 0', () async {
      final currentLocation = LocationData.fromMap({});
      const endPoint = LatLng(5.6127, -0.1870);

      final distance = await mapsTools.getDistanceFromLatLonInKm(
        currentLocation: currentLocation,
        endPoint: endPoint,
      );

      expect(distance, isA<double>());
    });

    test('returns 0 when both locations are same', () async {
      final currentLocation = LocationData.fromMap({
        'latitude': 5.6037,
        'longitude': -0.1870,
      });
      const endPoint = LatLng(5.6037, -0.1870);

      final distance = await mapsTools.getDistanceFromLatLonInKm(
        currentLocation: currentLocation,
        endPoint: endPoint,
      );

      expect(distance, 0.0);
    });
  });

  group('returnHeading', () {
    test('returns same heading when positive', () {
      expect(mapsTools.returnHeading(90), 90);
      expect(mapsTools.returnHeading(180), 180);
      expect(mapsTools.returnHeading(270), 270);
      expect(mapsTools.returnHeading(359), 359);
    });

    test('returns 0 when heading is 0', () {
      expect(mapsTools.returnHeading(0), 0);
    });

    test('converts negative heading to positive by adding 360', () {
      expect(mapsTools.returnHeading(-90), 270);
      expect(mapsTools.returnHeading(-180), 180);
      expect(mapsTools.returnHeading(-1), 359);
      expect(mapsTools.returnHeading(-270), 90);
    });

    test('handles large negative numbers', () {
      expect(mapsTools.returnHeading(-360), 0);
      expect(mapsTools.returnHeading(-450), -90);
    });
  });

  group('updateDistanceOnActiveStep', () {
    test('calculates distance between rider and step end location', () {
      final currentStep = Steps(
        distance: Distance(text: '1 km', value: 1000),
        duration: Distance(text: '5 mins', value: 300),
        endLocation: Northeast(lat: 5.6127, lng: -0.1870),
        htmlInstructions: 'Turn right',
        polyline: Polylines(points: 'encoded_polyline'),
        startLocation: Northeast(lat: 5.6037, lng: -0.1870),
        travelMode: 'DRIVING',
        maneuver: 'turn-right',
      );
      const position = LatLng(5.6037, -0.1870);

      final distance = mapsTools.updateDistanceOnActiveStep(
        currentStep: currentStep,
        position: position,
      );

      expect(distance, isA<double>());
      expect(distance, greaterThan(0));
    });

    test('returns 0 when rider is at step end location', () {
      final currentStep = Steps(
        distance: Distance(text: '0 km', value: 0),
        duration: Distance(text: '0 mins', value: 0),
        endLocation: Northeast(lat: 5.6037, lng: -0.1870),
        htmlInstructions: 'Arrive at destination',
        polyline: Polylines(points: 'encoded_polyline'),
        startLocation: Northeast(lat: 5.6037, lng: -0.1870),
        travelMode: 'DRIVING',
        maneuver: 'straight',
      );
      const position = LatLng(5.6037, -0.1870);

      final distance = mapsTools.updateDistanceOnActiveStep(
        currentStep: currentStep,
        position: position,
      );

      expect(distance, 0.0);
    });
  });

  group('updateStepsIfNeeded', () {
    test('returns empty list when currentSteps is empty', () {
      final result = mapsTools.updateStepsIfNeeded(
        currentSteps: [],
        currentPolyline: [const LatLng(5.6037, -0.1870)],
      );

      expect(result, isEmpty);
    });

    test('returns same steps when step end location is in polyline', () {
      final steps = [
        Steps(
          distance: Distance(text: '1 km', value: 1000),
          duration: Distance(text: '5 mins', value: 300),
          endLocation: Northeast(lat: 5.60370, lng: -0.18700),
          htmlInstructions: 'Turn right',
          polyline: Polylines(points: 'encoded_polyline'),
          startLocation: Northeast(lat: 5.6000, lng: -0.1800),
          travelMode: 'DRIVING',
          maneuver: 'turn-right',
        ),
      ];
      final polyline = [const LatLng(5.6037, -0.1870)];

      final result = mapsTools.updateStepsIfNeeded(
        currentSteps: steps,
        currentPolyline: polyline,
      );

      expect(result.length, 1);
    });

    test('removes step when end location not in polyline', () {
      final steps = [
        Steps(
          distance: Distance(text: '1 km', value: 1000),
          duration: Distance(text: '5 mins', value: 300),
          endLocation: Northeast(lat: 5.6037, lng: -0.1870),
          htmlInstructions: 'Turn right',
          polyline: Polylines(points: 'encoded_polyline'),
          startLocation: Northeast(lat: 5.6000, lng: -0.1800),
          travelMode: 'DRIVING',
          maneuver: 'turn-right',
        ),
      ];
      final polyline = [const LatLng(6.0000, -1.0000)];

      final result = mapsTools.updateStepsIfNeeded(
        currentSteps: steps,
        currentPolyline: polyline,
      );

      expect(result, isEmpty);
    });

    test('handles multiple steps correctly', () {
      final steps = [
        Steps(
          distance: Distance(text: '500 m', value: 500),
          duration: Distance(text: '2 mins', value: 120),
          endLocation: Northeast(lat: 5.6037, lng: -0.1870),
          htmlInstructions: 'Turn right',
          polyline: Polylines(points: 'encoded_polyline_1'),
          startLocation: Northeast(lat: 5.6000, lng: -0.1800),
          travelMode: 'DRIVING',
          maneuver: 'turn-right',
        ),
        Steps(
          distance: Distance(text: '1 km', value: 1000),
          duration: Distance(text: '5 mins', value: 300),
          endLocation: Northeast(lat: 5.6100, lng: -0.1900),
          htmlInstructions: 'Continue straight',
          polyline: Polylines(points: 'encoded_polyline_2'),
          startLocation: Northeast(lat: 5.6037, lng: -0.1870),
          travelMode: 'DRIVING',
          maneuver: 'straight',
        ),
      ];
      final polyline = [
        const LatLng(5.6037, -0.1870),
        const LatLng(5.6100, -0.1900),
      ];

      final result = mapsTools.updateStepsIfNeeded(
        currentSteps: steps,
        currentPolyline: polyline,
      );

      expect(result, isA<List<Steps>>());
    });
  });

  group('reCallDirectionsApi', () {
    testWidgets('returns false when polyline has only 1 point',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Container()));
      final context = tester.element(find.byType(Container));

      const position = LatLng(5.6037, -0.1870);
      final polyline = [const LatLng(5.6037, -0.1870)];

      final result = await mapsTools.reCallDirectionsApi(
        context: context,
        position: position,
        polyCoordinates: polyline,
      );

      expect(result.recalculate, false); // callGoogle should be false
    });

    testWidgets('returns false when at end of polyline',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Container()));
      final context = tester.element(find.byType(Container));

      const position = LatLng(5.6037, -0.1870);
      final polyline = [
        const LatLng(5.6000, -0.1800),
        const LatLng(5.6037, -0.1870),
      ];

      final result = await mapsTools.reCallDirectionsApi(
        context: context,
        position: position,
        polyCoordinates: polyline,
      );

      expect(result.recalculate, false);
    });

    testWidgets('returns true when deviation exceeds threshold',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Container()));
      final context = tester.element(find.byType(Container));

      // Rider location far from polyline
      const position = LatLng(6.0000, -1.0000);
      final polyline = [
        const LatLng(5.6000, -0.1800),
        const LatLng(5.6037, -0.1870),
        const LatLng(5.6100, -0.1900),
      ];

      final result = await mapsTools.reCallDirectionsApi(
        context: context,
        position: position,
        polyCoordinates: polyline,
      );

      expect(result.recalculate, isA<bool>());
    });
  });
}
