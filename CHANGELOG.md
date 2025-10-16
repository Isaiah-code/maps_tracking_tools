# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
