# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.8] - 2025-10-30

### Changed
- **BREAKING CHANGE**: Updated function parameters from `Position` object to `LatLng` object for improved flexibility and consistency
- **BREAKING CHANGE**: Renamed parameter `riderLocation` to `position` for more generic usage
- Affected functions: `reCallDirectionsApi` and `updateDistanceOnActiveStep`
- These changes allow easier integration with various location sources and simplify the API

### Migration Guide
If you're upgrading from 0.0.7 or earlier:

**Before (0.0.7):**
```dart
final result = await mapsTools.reCallDirectionsApi(
  context: context,
  riderLocation: positionObject, // Position type
  polyCoordinates: polyline,
);

final distance = mapsTools.updateDistanceOnActiveStep(
  currentStep: step,
  riderLocation: positionObject, // Position type
);
```

**After (0.0.8):**
```dart
final result = await mapsTools.reCallDirectionsApi(
  context: context,
  position: LatLng(lat, lng), // LatLng type, renamed parameter
  polyCoordinates: polyline,
);

final distance = mapsTools.updateDistanceOnActiveStep(
  currentStep: step,
  position: LatLng(lat, lng), // LatLng type, renamed parameter
);
```

## [0.0.7] - 2025-10-21

### Changed
- Upgraded package dependencies to latest compatible versions
- Improved package compatibility with newer Flutter projects

## [0.0.6] - 2025-10-17

### Changed
- Main README

## [0.0.5] - 2025-10-17

### Added
- Complete example app demonstrating all package features
- Interactive UI with 6 example demonstrations:
    - Distance calculation between coordinates (Accra to Kumasi)
    - Degree to radian conversion
    - Compass heading normalization
    - Current location distance calculation with real device GPS
    - Route deviation detection simulation
    - Navigation step distance tracking
- Example app README with setup instructions for Android and iOS
- Location permission handling in example app
- Loading states and error handling in example UI
- Informative result display card with detailed output

### Changed
- Enhanced developer onboarding with working code samples

## [0.0.4] - 2025-10-16

### Added
- Comprehensive documentation for all model classes (`Northeast`, `Distance`, `Steps`, `Polylines`)
- Detailed property-level documentation with examples and expected value ranges
- Common maneuver types documentation for `Steps.maneuver` property
- Cross-references between related model classes

### Changed
- Updated `reCallDirectionsApi` return type to use tuple syntax for improved type safety and clarity
- Enhanced model documentation with real-world usage examples

## [0.0.3] - 2025-10-16

### Added
- Comprehensive code documentation for all public methods
- Detailed doc comments with parameter descriptions and return types
- Practical usage examples for each function
- Special notes on deviation thresholds and precision values
- Class-level documentation explaining core features

### Changed
- Improved developer experience with IDE hover tooltip support
- Enhanced pub.dev documentation scoring with complete API documentation

## [0.0.2] - 2025-10-16

### Changed
- Added type annotation for `degToRad` function parameter for improved type safety and better IDE support

## [0.0.1] - 2025-10-16

### Added
- Initial release of Maps Tracking Tools
- `convertToKM` - Calculate distance between two LatLng coordinates using Haversine formula
- `getDistanceFromLatLonInKm` - Async distance calculation from LocationData to LatLng
- `degToRad` - Convert degrees to radians
- `returnHeading` - Normalize compass headings to 0-359 range
- `reCallDirectionsApi` - Detect route deviations and determine if recalculation is needed
- `updateStepsIfNeeded` - Update navigation steps based on current polyline
- `updateDistanceOnActiveStep` - Calculate distance between rider and current step endpoint
- Support for Google Maps Flutter integration
- Support for Location and Geolocator packages
- Comprehensive documentation and code examples
- Unit tests for all core functions
