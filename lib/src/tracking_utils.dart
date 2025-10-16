library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_tracking_toolbox/models/direction_object.dart';

class MapsTrackingTools{

  const MapsTrackingTools();


//get distance between rider and user
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

  String convertToKM({required LatLng pickup, required LatLng dropOff}) {
    const radius = 6371; // Radius of the earth in km
    final dLat = degToRad(degree: pickup.latitude - dropOff.latitude); // degToRad below
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

//degree to radians

  double degToRad({required double degree}) {
    return (degree * pi) / 180;
  }

  Future<(bool, List<LatLng>)> reCallDirectionsApi(
      {required BuildContext context, required Position riderLocation, required List<LatLng> polyCoordinates}) async {
    bool callGoogle = false;

    final latLngPosition =
    LatLng(riderLocation.latitude, riderLocation.longitude);

    if (polyCoordinates.length > 1) {
      for (int i = 0; i < polyCoordinates.length; i++) {
        if (i + 1 == polyCoordinates.length) {
          return (false, polyCoordinates);
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

    if (!context.mounted) return (false, polyCoordinates);

    return (callGoogle, polyCoordinates);
  }

//UPDATE STEPS IF NEEDED

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

//UPDATE DISTANCE
  double updateDistanceOnActiveStep(
      {required Steps currentStep, required Position riderLocation}) {
    return double.parse(convertToKM(
        pickup: LatLng(riderLocation.latitude, riderLocation.longitude),
        dropOff: LatLng(
            currentStep.endLocation!.lat!, currentStep.endLocation!.lng!)));
  }

  int returnHeading(int heading) {
    if (heading < 0) {
      return heading + 360;
    }

    return heading;
  }

}

