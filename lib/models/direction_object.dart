library;


class DirectionsObject {
  List<Routes>? routes;
  String? status;

  DirectionsObject({required this.routes, required this.status});
}

class GeocodedWaypoints {
  String? geocoderStatus;
  String? placeId;
  List<String>? types;

  GeocodedWaypoints(
      {required this.geocoderStatus,
        required this.placeId,
        required this.types});
}

class Routes {
  Bounds? bounds;
  String? copyrights;
  List<Legs>? legs;
  Polylines? overviewPolyline;
  String? summary;

  Routes({
    required this.bounds,
    required this.copyrights,
    required this.legs,
    required this.overviewPolyline,
    required this.summary,
  });
}

class Bounds {
  Northeast? northeast;
  Northeast? southwest;

  Bounds({required this.northeast, required this.southwest});
}

class Northeast {
  double? lat;
  double? lng;

  Northeast({required this.lat, required this.lng});
}

class Legs {
  Distance? distance;
  Distance? duration;
  String? endAddress;
  Northeast? endLocation;
  String? startAddress;
  Northeast? startLocation;
  List<Steps>? steps;

  Legs({
    required this.distance,
    required this.duration,
    required this.endAddress,
    required this.endLocation,
    required this.startAddress,
    required this.startLocation,
    required this.steps,
  });
}

class Distance {
  String? text;
  int? value;

  Distance({required this.text, required this.value});
}

class Steps {
  Distance? distance;
  Distance? duration;
  Northeast? endLocation;
  String? htmlInstructions;
  Polylines? polyline;
  Northeast? startLocation;
  String? travelMode;
  String? maneuver;

  Steps(
      {required this.distance,
        required this.duration,
        required this.endLocation,
        required this.htmlInstructions,
        required this.polyline,
        required this.startLocation,
        required this.travelMode,
        required this.maneuver});
}

class Polylines {
  String? points;

  Polylines({required this.points});
}
