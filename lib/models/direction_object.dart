library;

/// Represents a geographic coordinate with latitude and longitude.
///
/// This class is commonly used to represent locations in navigation steps,
/// such as start and end points of route segments.
///
/// **Example:**
/// ```dart
/// final location = Northeast(
///   lat: 5.6037,
///   lng: -0.1870,
/// );
/// print('Location: ${location.lat}, ${location.lng}'); // Location: 5.6037, -0.1870
/// ```
class Northeast {
  /// The latitude coordinate in decimal degrees.
  ///
  /// Positive values represent north of the equator,
  /// negative values represent south of the equator.
  /// Range: -90 to +90
  double? lat;

  /// The longitude coordinate in decimal degrees.
  ///
  /// Positive values represent east of the Prime Meridian,
  /// negative values represent west of the Prime Meridian.
  /// Range: -180 to +180
  double? lng;

  /// Creates a [Northeast] coordinate with the given latitude and longitude.
  ///
  /// **Parameters:**
  /// - [lat]: Latitude in decimal degrees
  /// - [lng]: Longitude in decimal degrees
  Northeast({required this.lat, required this.lng});
}

/// Represents distance or duration information in navigation responses.
///
/// This class is used for both distance and duration measurements,
/// providing both human-readable text and machine-readable numeric values.
///
/// **Example (Distance):**
/// ```dart
/// final distance = Distance(
///   text: '2.5 km',
///   value: 2500, // meters
/// );
/// ```
///
/// **Example (Duration):**
/// ```dart
/// final duration = Distance(
///   text: '5 mins',
///   value: 300, // seconds
/// );
/// ```
class Distance {
  /// Human-readable representation of the distance or duration.
  ///
  /// For distance: typically in format "X km" or "X m"
  /// For duration: typically in format "X mins" or "X hours"
  ///
  /// **Examples:**
  /// - "2.5 km"
  /// - "150 m"
  /// - "5 mins"
  /// - "1 hour 30 mins"
  String? text;

  /// Numeric value for programmatic use.
  ///
  /// For distance: value in meters
  /// For duration: value in seconds
  ///
  /// **Examples:**
  /// - Distance of 2.5 km = 2500
  /// - Duration of 5 minutes = 300
  int? value;

  /// Creates a [Distance] instance with text and numeric representations.
  ///
  /// **Parameters:**
  /// - [text]: Human-readable string representation
  /// - [value]: Numeric value (meters for distance, seconds for duration)
  Distance({required this.text, required this.value});
}

/// Represents a single navigation step in a route.
///
/// A step contains all information needed to guide a user through one segment
/// of a route, including distance, duration, instructions, and geometry.
/// This structure typically comes from the Google Maps Directions API.
///
/// **Example:**
/// ```dart
/// final step = Steps(
///   distance: Distance(text: '500 m', value: 500),
///   duration: Distance(text: '2 mins', value: 120),
///   startLocation: Northeast(lat: 5.6037, lng: -0.1870),
///   endLocation: Northeast(lat: 5.6087, lng: -0.1920),
///   htmlInstructions: 'Turn <b>right</b> onto Ring Road',
///   polyline: Polylines(points: 'encoded_polyline_string'),
///   travelMode: 'DRIVING',
///   maneuver: 'turn-right',
/// );
/// ```
class Steps {
  /// The distance covered in this navigation step.
  ///
  /// Contains both human-readable text (e.g., "500 m") and
  /// numeric value in meters for calculations.
  Distance? distance;

  /// The estimated time to complete this navigation step.
  ///
  /// Contains both human-readable text (e.g., "2 mins") and
  /// numeric value in seconds for calculations.
  Distance? duration;

  /// The ending coordinate of this step.
  ///
  /// This is where the user should be when completing this step,
  /// and typically where the next step begins.
  Northeast? endLocation;

  /// HTML-formatted navigation instructions for this step.
  ///
  /// May contain HTML tags for formatting (e.g., `<b>`, `<div>`).
  /// Should be rendered appropriately or have HTML tags stripped for display.
  ///
  /// **Example:**
  /// ```
  /// "Turn <b>right</b> onto Ring Road"
  /// "Continue straight to stay on <b>N1 Highway</b>"
  /// ```
  String? htmlInstructions;

  /// Encoded polyline representing the path geometry for this step.
  ///
  /// Contains an encoded string that can be decoded to get
  /// a series of lat/lng coordinates defining the step's path.
  /// Use a polyline decoder to convert to actual coordinates.
  Polylines? polyline;

  /// The starting coordinate of this step.
  ///
  /// This is where the user should be when beginning this step,
  /// and typically matches the end location of the previous step.
  Northeast? startLocation;

  /// The mode of transportation for this step.
  ///
  /// Common values:
  /// - "DRIVING"
  /// - "WALKING"
  /// - "BICYCLING"
  /// - "TRANSIT"
  String? travelMode;

  /// The type of maneuver to perform at this step.
  ///
  /// Common values:
  /// - "turn-left"
  /// - "turn-right"
  /// - "turn-slight-left"
  /// - "turn-slight-right"
  /// - "turn-sharp-left"
  /// - "turn-sharp-right"
  /// - "straight"
  /// - "ramp-left"
  /// - "ramp-right"
  /// - "merge"
  /// - "fork-left"
  /// - "fork-right"
  /// - "roundabout-left"
  /// - "roundabout-right"
  ///
  /// Can be null for steps without a specific maneuver.
  String? maneuver;

  /// Creates a [Steps] instance representing a navigation step.
  ///
  /// All parameters are required but can be null, as different API responses
  /// may provide different levels of detail.
  ///
  /// **Parameters:**
  /// - [distance]: Distance information for this step
  /// - [duration]: Duration information for this step
  /// - [endLocation]: Ending coordinates
  /// - [htmlInstructions]: Navigation instructions with HTML formatting
  /// - [polyline]: Encoded polyline for the step's path
  /// - [startLocation]: Starting coordinates
  /// - [travelMode]: Mode of transportation
  /// - [maneuver]: Type of maneuver to perform
  Steps({
    required this.distance,
    required this.duration,
    required this.endLocation,
    required this.htmlInstructions,
    required this.polyline,
    required this.startLocation,
    required this.travelMode,
    required this.maneuver,
  });
}

/// Represents an encoded polyline string for a route path.
///
/// Polylines use a compressed format to efficiently represent a series of
/// coordinates. The encoded string can be decoded to get the actual lat/lng
/// points that make up a path.
///
/// **Example:**
/// ```dart
/// final polyline = Polylines(
///   points: 'abc123xyz...', // Encoded polyline string from API
/// );
/// ```
///
/// **Note:** Use a polyline decoder library to convert the encoded
/// string to actual coordinates for display on a map.
///
/// See: [Google's Polyline Encoding Algorithm](https://developers.google.com/maps/documentation/utilities/polylinealgorithm)
class Polylines {
  /// The encoded polyline string.
  ///
  /// This is a compressed representation of a path consisting of
  /// multiple latitude/longitude coordinates. Decode this string
  /// to get the actual coordinate points.
  ///
  /// **Example encoded string:**
  /// ```
  /// "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
  /// ```
  String? points;

  /// Creates a [Polylines] instance with an encoded polyline string.
  ///
  /// **Parameters:**
  /// - [points]: Encoded polyline string from navigation API
  Polylines({required this.points});
}
