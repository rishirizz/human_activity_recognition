# Human Activity Recognition

A Flutter package for detecting human activities such as walking, running, and standing using accelerometer and gyroscope sensors.

## Usage

```dart
import 'package:human_activity_recognition/human_activity_recognition.dart';

// Create instance
final HumanActivityRecognition har = HumanActivityRecognition();

// Start detecting activity
har.startDetection();

// Listen to activity stream
har.activityStream.listen((Activity activity) {
  print("Detected activity: $activity");
});

// Stop detection when done
har.stopDetection();

