import 'package:flutter_test/flutter_test.dart';
import 'package:task_thingy/utils/misc.dart';

void main() {
  group('DateTime.toTaskFormat', () {
    test('pads single-digit hour and minute', () {
      final dt = DateTime(2025, 1, 1, 3, 5);
      expect(dt.toTaskFormat(), '03:05');
    });

    test('does not pad double-digit hour and minute', () {
      final dt = DateTime(2025, 1, 1, 14, 30);
      expect(dt.toTaskFormat(), '14:30');
    });

    test('midnight', () {
      final dt = DateTime(2025, 1, 1, 0, 0);
      expect(dt.toTaskFormat(), '00:00');
    });

    test('end of day', () {
      final dt = DateTime(2025, 1, 1, 23, 59);
      expect(dt.toTaskFormat(), '23:59');
    });
  });

  group('DateTime.getWeekDay', () {
    test('returns correct abbreviation for each day', () {
      // 2025-06-02 is a Monday
      expect(DateTime(2025, 6, 2).getWeekDay(), 'Mon');
      expect(DateTime(2025, 6, 3).getWeekDay(), 'Tue');
      expect(DateTime(2025, 6, 4).getWeekDay(), 'Wed');
      expect(DateTime(2025, 6, 5).getWeekDay(), 'Thu');
      expect(DateTime(2025, 6, 6).getWeekDay(), 'Fri');
      expect(DateTime(2025, 6, 7).getWeekDay(), 'Sat');
      expect(DateTime(2025, 6, 8).getWeekDay(), 'Sun');
    });
  });

  group('DateTime.getMonth', () {
    test('returns full month name for all 12 months', () {
      final expected = [
        'January', 'February', 'March', 'April',
        'May', 'June', 'July', 'August',
        'September', 'October', 'November', 'December',
      ];
      for (var i = 0; i < 12; i++) {
        expect(DateTime(2025, i + 1, 1).getMonth(), expected[i]);
      }
    });
  });
}
