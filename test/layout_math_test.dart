import 'package:flutter_test/flutter_test.dart';
import 'package:task_thingy/utils/layoutMath.dart';

void main() {
  group('TimeLineLayout.durationToHeight', () {
    test('one hour returns 60 minutes', () {
      // DateTime.toString() produces ISO-ish format: "2025-06-01 09:00:00.000"
      final start = DateTime(2025, 6, 1, 9, 0).toString();
      final end = DateTime(2025, 6, 1, 10, 0).toString();
      expect(TimeLineLayout.durationToMinutes(start, end), 60.0);
    });

    test('30 minutes', () {
      final start = DateTime(2025, 6, 1, 9, 0).toString();
      final end = DateTime(2025, 6, 1, 9, 30).toString();
      expect(TimeLineLayout.durationToMinutes(start, end), 30.0);
    });

    test('zero duration', () {
      final start = DateTime(2025, 6, 1, 9, 0).toString();
      expect(TimeLineLayout.durationToMinutes(start, start), 0.0);
    });

    test('multi-hour duration', () {
      final start = DateTime(2025, 6, 1, 9, 0).toString();
      final end = DateTime(2025, 6, 1, 12, 30).toString();
      expect(TimeLineLayout.durationToMinutes(start, end), 210.0);
    });

    test('negative duration (end before start) returns negative', () {
      final start = DateTime(2025, 6, 1, 10, 0).toString();
      final end = DateTime(2025, 6, 1, 9, 0).toString();
      expect(TimeLineLayout.durationToMinutes(start, end), -60.0);
    });
  });

  group('TimeLineLayout.extractHourMinute', () {
    test('extracts HH:MM from DateTime string', () {
      // DateTime.toString() → "2025-06-01 09:05:00.000"
      final s = DateTime(2025, 6, 1, 9, 5).toString();
      expect(TimeLineLayout.extractHourMinute(s), '09:05');
    });

    test('extracts from afternoon time', () {
      final s = DateTime(2025, 6, 1, 14, 30).toString();
      expect(TimeLineLayout.extractHourMinute(s), '14:30');
    });

    test('midnight', () {
      final s = DateTime(2025, 6, 1, 0, 0).toString();
      expect(TimeLineLayout.extractHourMinute(s), '00:00');
    });
  });
}
