# Maps Tracking Tools

A Flutter package providing utility functions for real-time location tracking, distance calculations, and route management for maps-based applications.

## Features

- 🗺️ **Distance Calculations** - Calculate distances between geographic coordinates using the Haversine formula
- 📍 **Location Tracking** - Track rider/user positions relative to predefined routes
- 🧭 **Heading Normalization** - Convert and normalize compass headings
- 🛣️ **Route Deviation Detection** - Detect when users deviate from planned routes
- 📊 **Step Management** - Update and manage navigation steps based on current position

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  maps_tracking_toolbox: ^0.0.7
```

Then run:

```bash
flutter pub get
```

## Usage

### Import the package

```dart
import 'package:maps_tracking_toolbox/maps_tracking_toolbox.dart';
```

### Initialize the tools

```dart
const mapsTools = MapsTrackingTools();
```

### Calculate distance between two points

```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Calculate distance in kilometers
final distance = mapsTools.convertToKM(
  pickup: LatLng(5.6037, -0.1870),    // Accra
  dropOff: LatLng(6.6885, -1.6244),   // Kumasi
);
print('Distance: $distance km');  // Distance: 200.45 km
```

### Get distance from current location

```dart
import 'package:location/location.dart';

final currentLocation = LocationData.fromMap({
  'latitude': 5.6037,
  'longitude': -0.1870,
});

final distanceKm = await mapsTools.getDistanceFromLatLonInKm(
  currentLocation: currentLocation,
  endPoint: LatLng(6.6885, -1.6244),
);
print('Distance: $distanceKm km');
```

### Normalize compass heading

```dart
// Convert negative headings to positive (0-359 range)
final heading = mapsTools.returnHeading(-90);
print(heading);  // 270
```

### Check for route deviations

```dart
import 'package:geolocator/geolocator.dart';

final riderLocation = await Geolocator.getCurrentPosition();
final polyCoordinates = [
  LatLng(5.6000, -0.1800),
  LatLng(5.6037, -0.1870),
  LatLng(5.6100, -0.1900),
];

final (shouldRecall, updatedPoly) = await mapsTools.reCallDirectionsApi(
  context: context,
  riderLocation: riderLocation,
  polyCoordinates: polyCoordinates,
);

if (shouldRecall) {
  // Rider has deviated from route - fetch new directions
  print('Recalculating route...');
}
```

### Update navigation steps

```dart
final currentSteps = [...]; // Your list of Steps
final currentPolyline = [...]; // Your polyline coordinates

final updatedSteps = mapsTools.updateStepsIfNeeded(
  currentSteps: currentSteps,
  currentPolyline: currentPolyline,
);
```

### Calculate distance to next step

```dart
final currentStep = Steps(...); // Your current navigation step
final riderLocation = await Geolocator.getCurrentPosition();

final distanceToStep = mapsTools.updateDistanceOnActiveStep(
  currentStep: currentStep,
  riderLocation: riderLocation,
);
print('Distance to next turn: $distanceToStep km');
```

## API Reference

### `convertToKM`

Calculates the distance between two geographic coordinates using the Haversine formula.

**Parameters:**
- `pickup` (LatLng) - Starting coordinate
- `dropOff` (LatLng) - Ending coordinate

**Returns:** String representation of distance in kilometers (2 decimal places)

### `getDistanceFromLatLonInKm`

Async wrapper for calculating distance from LocationData to LatLng.

**Parameters:**
- `currentLocation` (LocationData) - Current location from location package
- `endPoint` (LatLng) - Destination coordinate

**Returns:** Future<double> - Distance in kilometers

### `degToRad`

Converts degrees to radians.

**Parameters:**
- `deg` (num) - Angle in degrees

**Returns:** double - Angle in radians

### `returnHeading`

Normalizes heading values to 0-359 range.

**Parameters:**
- `heading` (int) - Compass heading (can be negative)

**Returns:** int - Normalized heading (0-359)

### `reCallDirectionsApi`

Detects if rider has deviated from route and determines if new directions are needed.

**Parameters:**
- `context` (BuildContext) - Flutter context
- `riderLocation` (Position) - Current rider position
- `polyCoordinates` (List<LatLng>) - Route polyline coordinates

**Returns:** Future<(bool, List<LatLng>)> - Tuple of (shouldRecalculate, updatedPolyline)

### `updateStepsIfNeeded`

Updates navigation steps based on current polyline.

**Parameters:**
- `currentSteps` (List<Steps>) - Current navigation steps
- `currentPolyline` (List<LatLng>) - Current route polyline

**Returns:** List<Steps> - Updated steps list

### `updateDistanceOnActiveStep`

Calculates distance between rider and end of current navigation step.

**Parameters:**
- `currentStep` (Steps) - Current active navigation step
- `riderLocation` (Position) - Rider's current position

**Returns:** double - Distance in kilometers

## Dependencies

This package depends on:
- `google_maps_flutter` - For LatLng coordinate handling
- `location` - For LocationData
- `geolocator` - For Position data


## Additional Information

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Issues

If you encounter any issues, please file them on the [GitHub issue tracker](https://github.com/isaiah-code/maps_tracking_tools/issues).


## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes in each version.

## Author

Amo Mensah Isaiah - [GitHub](https://github.com/isaiah-code)

---

If you find this package useful, please give it a ⭐ on [GitHub](https://github.com/isaiah-code/maps_tracking_tools)!
