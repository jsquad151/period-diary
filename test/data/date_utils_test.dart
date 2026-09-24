import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/data/date_utils.dart';

void main() {
  test('late-night local time stays on its own calendar date', () {
    expect(formatLocalDate(DateTime(2026, 9, 23, 23, 59)), '2026-09-23');
  });

  test('just after midnight is the next date', () {
    expect(formatLocalDate(DateTime(2026, 9, 24, 0, 1)), '2026-09-24');
  });

  test('parse/format round-trips', () {
    expect(formatLocalDate(parseLocalDate('2026-02-28')), '2026-02-28');
    expect(formatLocalTime(DateTime(2026, 1, 1, 9, 5)), '09:05');
  });

  test('addDays crosses month, year and leap boundaries', () {
    expect(addDaysToLocalDate('2026-09-30', 1), '2026-10-01');
    expect(addDaysToLocalDate('2026-12-31', 1), '2027-01-01');
    expect(addDaysToLocalDate('2028-02-28', 1), '2028-02-29');
    expect(addDaysToLocalDate('2026-03-01', -1), '2026-02-28');
  });

  test('addDays always advances exactly one calendar day (DST-safe)', () {
    // Dates around common DST transitions in several hemispheres.
    for (final start in ['2026-03-07', '2026-03-28', '2026-10-24', '2026-04-04']) {
      final next = addDaysToLocalDate(start, 1);
      final expected = DateTime(
          parseLocalDate(start).year, parseLocalDate(start).month, parseLocalDate(start).day + 1);
      expect(next, formatLocalDate(expected));
    }
    expect(addDaysToLocalDate('2026-03-08', 1), '2026-03-09');
  });

  test('localDateRange is inclusive', () {
    expect(localDateRange('2026-09-29', '2026-10-02'),
        ['2026-09-29', '2026-09-30', '2026-10-01', '2026-10-02']);
    expect(localDateRange('2026-09-29', '2026-09-29'), ['2026-09-29']);
  });

  test('validation', () {
    expect(isValidLocalDate('2026-09-23'), isTrue);
    expect(isValidLocalDate('2026-02-30'), isFalse);
    expect(isValidLocalDate('23-09-2026'), isFalse);
    expect(isValidLocalTime('23:59'), isTrue);
    expect(isValidLocalTime('24:00'), isFalse);
  });
}
