library human_activity_recognition;

import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vector_math/vector_math.dart';

/// Enum to represent the different activities detected
enum Activity { walking, running, standing, sitting, unknown }

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
      // You can process gyroscope data here for more advanced activity detection
      // For example, if you want to detect phone rotation or fast movements
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
