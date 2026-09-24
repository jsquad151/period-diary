import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/data/catchup.dart';
import 'package:period_diary/data/day_status.dart';

DaySummary quiet(String d) => DaySummary(d)..hasQuietCheckIn = true;

void main() {
  test('nothing recorded yet: nobody is nagged', () {
    expect(missedDays(today: '2026-09-24', summaries: {}), isEmpty);
  });

  test('lists unrecorded days between the first record and yesterday', () {
    final s = {'2026-09-20': quiet('2026-09-20')};
    expect(missedDays(today: '2026-09-24', summaries: s),
        ['2026-09-21', '2026-09-22', '2026-09-23']);
  });

  test('today is never offered', () {
    final s = {'2026-09-23': quiet('2026-09-23')};
    expect(missedDays(today: '2026-09-24', summaries: s), isEmpty);
  });

  test('recorded days are skipped over', () {
    final s = {
      '2026-09-20': quiet('2026-09-20'),
      '2026-09-22': quiet('2026-09-22'),
    };
    expect(missedDays(today: '2026-09-24', summaries: s), ['2026-09-21', '2026-09-23']);
  });

  test('"I don\'t remember" days are not re-asked but remain unobserved', () {
    final s = {'2026-09-20': quiet('2026-09-20')};
    final result = missedDays(
        today: '2026-09-24', summaries: s, skipped: {'2026-09-21', '2026-09-22'});
    expect(result, ['2026-09-23']);
    expect(s.containsKey('2026-09-21'), isFalse);
  });

  test('lookback limits how far back we ask', () {
    final s = {'2026-08-01': quiet('2026-08-01')};
    final result = missedDays(today: '2026-09-24', summaries: s, lookbackDays: 3);
    expect(result, ['2026-09-21', '2026-09-22', '2026-09-23']);
  });
}
