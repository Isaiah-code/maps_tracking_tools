# Maps Tracking Toolbox Example

A complete example app demonstrating all features of the Maps Tracking Tools package.

## Features Demonstrated

This example app showcases:

1. **Distance Calculations** - Calculate distance between Accra and Kumasi using Haversine formula
2. **Degree to Radian Conversion** - Convert compass degrees to radians
3. **Heading Normalization** - Normalize negative compass headings to 0-359 range
4. **Current Location Distance** - Get distance from your current location to a destination
5. **Route Deviation Detection** - Detect when a rider deviates from planned route
6. **Navigation Step Distance** - Calculate remaining distance to next navigation step

## Getting Started

### Prerequisites

Make sure you have Flutter installed. Check with:

```bash
flutter doctor
```

### Installation

1. Navigate to the example directory:

```bash
cd example
```

2. Get dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Platform Setup

### Android

Add location permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS

Add location permissions to `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location for distance calculations.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location for distance calculations.</string>
```

## Usage

Tap any button in the app to see the corresponding feature in action. Results are displayed in the card at the top of the screen.

## Notes

- The "Distance from Current Location" feature requires location permissions
- Sample coordinates use Accra and Kumasi, Ghana as examples
- Route deviation detection uses a simulated polyline for demonstration
- Navigation step example uses mock data to show structure

## Learn More

For more information about the Maps Tracking Tools package, check out the [main README](../README.md).
