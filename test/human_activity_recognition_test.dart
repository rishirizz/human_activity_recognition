import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:human_activity_recognition/human_activity_recognition.dart';

void main()  {
   WidgetsFlutterBinding.ensureInitialized();
  group('HumanActivityRecognition', () {
    late HumanActivityRecognition har;

    setUp(() {
      har = HumanActivityRecognition();
    });

    test('initial state', () {
      expect(har.activityStream, isA<Stream<Activity>>());
    });

    test('classifyActivity detects walking', () {
      // Simulating accelerometer data for walking (magnitude between 3 and 12)
      final activity = har.classifyActivity(2.0, 2.0, 1.0);
      expect(activity, Activity.walking);
    });

    test('classifyActivity detects running', () {
      // Simulating accelerometer data for running (magnitude greater than 12)
      final activity = har.classifyActivity(8.0, 7.0, 3.0);
      expect(activity, Activity.running);
    });

    test('classifyActivity detects standing', () {
      // Simulating accelerometer data for standing (magnitude less than or equal to 3)
      final activity = har.classifyActivity(0.5, 0.5, 0.5);
      expect(activity, Activity.standing);
    });

    test('Activity stream emits walking', () async {
      har.startDetection();

      // Simulate accelerometer event for walking
      har.activityController.add(Activity.walking);

      await expectLater(har.activityStream, emits(Activity.walking));
      har.stopDetection();
    });

    test('Activity stream emits running', () async {
      har.startDetection();

      // Simulate accelerometer event for running
      har.activityController.add(Activity.running);

      await expectLater(har.activityStream, emits(Activity.running));
      har.stopDetection();
    });
  });
}
