library human_activity_recognition;

import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vector_math/vector_math.dart';

/// Enum to represent the different activities detected
enum Activity { walking, running, standing, sitting, fastMovement, unknown }

/// A class that provides human activity recognition based on sensor data
class HumanActivityRecognition {
  final StreamController<Activity> activityController =
      StreamController<Activity>.broadcast();
  StreamSubscription? _accelerometerSubscription;
  StreamSubscription? _gyroscopeSubscription;

  Stream<Activity> get activityStream => activityController.stream;

  /// Start listening to sensor data to detect activities
  void startDetection() {
    // Listen to accelerometer data
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      final activity = classifyActivity(event.x, event.y, event.z);
      activityController.add(activity);
    });

    // Listen to gyroscope data
    _gyroscopeSubscription = gyroscopeEventStream().listen((event) {
      double gyroscopeMagnitude =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (gyroscopeMagnitude > 2.0) {
        // Threshold for detecting fast movements
        print(
            'Fast movement detected! Gyroscope: x=${event.x}, y=${event.y}, z=${event.z}');
        activityController.add(Activity.fastMovement);
      } else {
        print('Gyroscope: x=${event.x}, y=${event.y}, z=${event.z}');
      }
    });
  }

  /// Stop listening to sensor data
  void stopDetection() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    activityController.close();
  }

  /// Classify the activity based on accelerometer data
  Activity classifyActivity(double x, double y, double z) {
    // A simple algorithm to classify the activity based on accelerometer values

    final magnitude = Vector3(x, y, z).length;

    if (magnitude > 12) {
      return Activity.running;
    } else if (magnitude > 3 && magnitude <= 12) {
      return Activity.walking;
    } else if (magnitude <= 3) {
      return Activity.standing;
    }

    return Activity.unknown;
  }
}
