library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_tracking_toolbox/models/direction_object.dart';

/// A collection of utility functions for real-time location tracking,
/// distance calculations, and route management in maps-based applications.
///
/// This class provides tools for:
/// - Calculating distances between geographic coordinates
/// - Detecting route deviations
/// - Managing navigation steps
/// - Normalizing compass headings
class MapsTrackingTools {
  /// Creates a [MapsTrackingTools] instance.
  ///
  /// The constructor parameter is currently unused but reserved for future extensions.
  const MapsTrackingTools();

  /// Calculates the distance between the current location and a destination endpoint.
  ///
  /// Uses the Haversine formula to calculate the great-circle distance between
  /// two points on Earth specified in decimal degrees.
  ///
  /// **Parameters:**
  /// - [currentLocation]: The rider's or user's current location
  /// - [endPoint]: The destination coordinates
  ///
  /// **Returns:** The distance in kilometers as a double
  ///
  /// **Example:**
  /// ```dart
  /// final currentLocation = LocationData.fromMap({
  ///   'latitude': 5.6037,
  ///   'longitude': -0.1870,
  /// });
  /// final endpoint = LatLng(6.6885, -1.6244);
  /// final distance = await mapsTools.getDistanceFromLatLonInKm(
  ///   currentLocation: currentLocation,
  ///   endPoint: endpoint,
  /// );
  /// print('Distance: $distance km');
  ///
  Future<double> getDistanceFromLatLonInKm({
    required LocationData currentLocation,
    required LatLng endPoint,
  }) async {
    final stringgyDistance = convertToKM(
      pickup:
          LatLng(currentLocation.latitude ?? 0, currentLocation.longitude ?? 0),
      dropOff: endPoint,
    );

    return double.parse(stringgyDistance);
  }

  /// Calculates the distance between two geographic coordinates using the Haversine formula.
  ///
  /// The Haversine formula determines the great-circle distance between two points
  /// on a sphere given their longitudes and latitudes.
  ///
  /// **Parameters:**
  /// - [pickup]: Starting coordinate (latitude, longitude)
  /// - [dropOff]: Ending coordinate (latitude, longitude)
  ///
  /// **Returns:** String representation of distance in kilometers with 2 decimal places
  ///
  /// **Example:**
  /// ```dart
  /// final distance = mapsTools.convertToKM(
  ///   pickup: LatLng(5.6037, -0.1870),  // Accra
  ///   dropOff: LatLng(6.6885, -1.6244), // Kumasi
  /// );
  /// print(distance); // "200.45"
  /// ```
  String convertToKM({required LatLng pickup, required LatLng dropOff}) {
    const radius = 6371; // Radius of the earth in km
    final dLat =
        degToRad(degree: pickup.latitude - dropOff.latitude); // degToRad below
    final dLon = degToRad(degree: pickup.longitude - dropOff.longitude);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degToRad(degree: dropOff.latitude)) *
            cos(degToRad(degree: pickup.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = radius * c; // Distance in km

    return distance.toStringAsFixed(2);
  }

  /// Converts an angle from degrees to radians.
  ///
  /// **Parameters:**
  /// - [deg]: Angle in degrees (can be positive or negative)
  ///
  /// **Returns:** Angle in radians as a double
  ///
  /// **Example:**
  /// ```dart
  /// final radians = mapsTools.degToRad(180);
  /// print(radians); // 3.14159... (π)
  /// ```
  double degToRad({required double degree}) {
    return (degree * pi) / 180;
  }

  /// Detects if a rider has deviated from the planned route and determines
  /// if the Directions API should be called again for route recalculation.
  ///
  /// The function checks if the rider is moving away from the route by comparing
  /// distances to consecutive polyline points. If deviation exceeds 50 meters (0.05 km),
  /// it signals that a new route should be calculated.
  ///
  /// **Parameters:**
  /// - [context]: Flutter BuildContext for checking if widget is still mounted
  /// - [riderLocation]: Current position of the rider
  /// - [polyCoordinates]: List of coordinates representing the planned route
  ///
  /// **Returns:** A tuple containing:
  ///   - `bool`: Whether to recalculate the route (true if deviation detected)
  ///   - `List<LatLng>`: Updated polyline coordinates with passed points removed
  ///
  /// **Deviation threshold:** 0.05 km (50 meters)
  ///
  /// **Example:**
  /// ```dart
  /// final (shouldRecall, updatedPoly) = await mapsTools.reCallDirectionsApi(
  ///   context: context,
  ///   riderLocation: currentPosition,
  ///   polyCoordinates: routePolyline,
  /// );
  ///
  /// if (shouldRecall) {
  ///   // Fetch new directions from Google Maps API
  ///   await fetchNewRoute();
  /// }
  /// ```
  Future<({bool recalculate, List<LatLng> polyCoordinates})>
      reCallDirectionsApi(
          {required BuildContext context,
          required Position riderLocation,
          required List<LatLng> polyCoordinates}) async {
    bool callGoogle = false;

    final latLngPosition =
        LatLng(riderLocation.latitude, riderLocation.longitude);

    if (polyCoordinates.length > 1) {
      for (int i = 0; i < polyCoordinates.length; i++) {
        if (i + 1 == polyCoordinates.length) {
          return (recalculate: false, polyCoordinates: polyCoordinates);
        }
        final distanceKm1 = double.parse(
            convertToKM(pickup: latLngPosition, dropOff: polyCoordinates[i]));
        final distanceKm2 = double.parse(convertToKM(
            pickup: latLngPosition, dropOff: polyCoordinates[i + 1]));

        if (distanceKm1 > distanceKm2) {
          //meaning he is on the right path

          polyCoordinates.removeRange(i, i + 1);
        } else {
          //there is a deviation. check for upward adjustment

          if (distanceKm1 > 0.05) {
            callGoogle = true;
          } else {
            break;
          }
        }
      }
    }

    if (!context.mounted) {
      return (recalculate: false, polyCoordinates: polyCoordinates);
    }

    return (recalculate: callGoogle, polyCoordinates: polyCoordinates);
  }

  /// Updates the navigation steps list by removing steps that have been passed.
  ///
  /// Compares step end locations with the current polyline coordinates.
  /// If a step's end location is no longer in the polyline, that step is removed.
  ///
  /// **Parameters:**
  /// - [currentSteps]: List of navigation steps to check
  /// - [currentPolyline]: Current route polyline coordinates
  ///
  /// **Returns:** Updated list of [Steps] with passed steps removed
  ///
  /// **Note:** Coordinates are compared with 5 decimal place precision
  ///
  /// **Example:**
  /// ```dart
  /// final updatedSteps = mapsTools.updateStepsIfNeeded(
  ///   currentSteps: navigationSteps,
  ///   currentPolyline: routePolyline,
  /// );
  /// // updatedSteps now only contains upcoming steps
  /// ```
  List<Steps> updateStepsIfNeeded(
      {required List<Steps> currentSteps,
      required List<LatLng> currentPolyline}) {
    List<Steps> holderSteps = currentSteps;

    if (currentSteps.isEmpty) {
      return currentSteps;
    }

    for (var step in holderSteps) {
      if (currentPolyline.contains(LatLng(
          double.parse(step.endLocation!.lat!.toStringAsFixed(5)),
          double.parse(step.endLocation!.lng!.toStringAsFixed(5))))) {
        return currentSteps;
      } else {
        currentSteps.remove(step);
        return currentSteps;
      }
    }

    return currentSteps;
  }

  /// Calculates the remaining distance from the rider's current position
  /// to the end of the active navigation step.
  ///
  /// **Parameters:**
  /// - [currentStep]: The active navigation step
  /// - [riderLocation]: Rider's current position
  ///
  /// **Returns:** Distance in kilometers as a double
  ///
  /// **Example:**
  /// ```dart
  /// final distanceToTurn = mapsTools.updateDistanceOnActiveStep(
  ///   currentStep: activeStep,
  ///   riderLocation: riderPosition,
  /// );
  /// print('In $distanceToTurn km, turn right');
  /// ```
  double updateDistanceOnActiveStep(
      {required Steps currentStep, required Position riderLocation}) {
    return double.parse(convertToKM(
        pickup: LatLng(riderLocation.latitude, riderLocation.longitude),
        dropOff: LatLng(
            currentStep.endLocation!.lat!, currentStep.endLocation!.lng!)));
  }

  /// Normalizes a compass heading to the standard 0-359 degree range.
  ///
  /// Converts negative heading values to their positive equivalent by adding 360.
  /// This is useful when working with compass sensors that may return negative values.
  ///
  /// **Parameters:**
  /// - [heading]: Compass heading in degrees (can be negative)
  ///
  /// **Returns:** Normalized heading in the range 0-359 degrees
  ///
  /// **Example:**
  /// ```dart
  /// final normalized = mapsTools.returnHeading(-90);
  /// print(normalized); // 270
  ///
  /// final alreadyPositive = mapsTools.returnHeading(180);
  /// print(alreadyPositive); // 180
  /// ```
  int returnHeading(int heading) {
    if (heading < 0) {
      return heading + 360;
    }

    return heading;
  }
}
