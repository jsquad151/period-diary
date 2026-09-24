import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/data/database.dart';
import 'package:period_diary/data/day_status.dart';
import 'package:period_diary/data/insights.dart';
import 'package:period_diary/data/repository.dart';

Future<Insights> compute(AppDatabase db,
    {String today = '2026-09-30', String? from, String? to}) async {
  return computeInsights(
    today: today,
    from: from,
    to: to,
    summaries: buildDaySummaries(
      checkIns: await db.select(db.dayCheckIns).get(),
      fluids: await db.select(db.fluidObservations).get(),
      libidos: await db.select(db.libidoEvents).get(),
      moods: await db.select(db.moodEvents).get(),
      symptoms: await db.select(db.physicalSymptoms).get(),
      notes: await db.select(db.dailyNotes).get(),
    ),
    fluids: await db.select(db.fluidObservations).get(),
    libidos: await db.select(db.libidoEvents).get(),
    moods: await db.select(db.moodEvents).get(),
    symptoms: await db.select(db.physicalSymptoms).get(),
  );
}

void main() {
  late AppDatabase db;
  late Repository repo;

  setUp(() {
    db = AppDatabase.memory();
    repo = Repository(db);
  });
  tearDown(() => db.close());

  test('no data: empty insights, nothing invented', () async {
    final i = await compute(db);
    expect(i.isEmpty, isTrue);
    expect(i.unobservedDays, 0);
  });

  test('coverage splits recorded, quiet and unobserved days', () async {
    await repo.markQuiet('2026-09-01');
    await repo.saveFluid(localDate: '2026-09-03', colours: ['brown']);
    final i = await compute(db, today: '2026-09-05');
    expect(i.from, '2026-09-01');
    expect(i.to, '2026-09-05');
    expect(i.confirmedQuietDays, 1);
    expect(i.notableDays, 1);
    expect(i.unobservedDays, 3); // 2nd, 4th, 5th: missing data, not "normal"
  });

  test('counts are event counts, not percentages of all days', () async {
    await repo.saveFluid(localDate: '2026-09-01', colours: ['brown']);
    for (final d in ['2026-09-02', '2026-09-10', '2026-09-20']) {
      await repo.saveLibido(localDate: d, direction: 'unusually_high');
    }
    await repo.saveLibido(localDate: '2026-09-21', direction: 'unusually_low');
    final i = await compute(db);
    expect(i.highLibido, 3);
    expect(i.lowLibido, 1);
  });

  test('mood and symptom counts', () async {
    await repo.markQuiet('2026-09-01');
    await repo.saveMood(localDate: '2026-09-02', categories: ['irritable_angry', 'low_sad']);
    await repo.saveMood(localDate: '2026-09-03', categories: ['irritable_angry']);
    await repo.saveSymptom(localDate: '2026-09-03', symptomType: 'cramps');
    final i = await compute(db);
    expect(i.moodCounts, {'irritable_angry': 2, 'low_sad': 1});
    expect(i.symptomCounts, {'cramps': 1});
  });

  test('longest run containing brown material uses consecutive days only', () async {
    for (final d in ['2026-09-01', '2026-09-02', '2026-09-04', '2026-09-05', '2026-09-06']) {
      await repo.saveFluid(localDate: d, colours: ['dark_brown']);
    }
    final run = (await compute(db)).longestBrownRun!;
    expect((run.start, run.end, run.length), ('2026-09-04', '2026-09-06', 3));
  });

  test('gap between separate runs of red blood', () async {
    // Run 1: 5th-6th. Run 2: 17th. Run 3: 30th.  Intervals: 11 and 13 days.
    for (final d in ['2026-09-05', '2026-09-06', '2026-09-17', '2026-09-30']) {
      await repo.saveFluid(localDate: d, colours: ['red'], bloodPresence: 'definite');
    }
    expect((await compute(db)).shortestGapBetweenRedRuns, 11);
  });

  test('a single red run has no gap to report', () async {
    await repo.saveFluid(localDate: '2026-09-05', colours: ['red']);
    await repo.saveFluid(localDate: '2026-09-06', colours: ['red']);
    expect((await compute(db)).shortestGapBetweenRedRuns, isNull);
  });

  test('associations are descriptive counts within a window before red blood', () async {
    await repo.saveFluid(localDate: '2026-09-15', colours: ['red']);
    await repo.saveLibido(localDate: '2026-09-10', direction: 'unusually_high'); // 5 before
    await repo.saveLibido(localDate: '2026-09-01', direction: 'unusually_high'); // too early
    await repo.saveLibido(localDate: '2026-09-20', direction: 'unusually_high'); // after
    await repo.saveMood(localDate: '2026-09-11', categories: ['irritable_angry']); // 4 before
    final a = (await compute(db)).associations;
    final libido = a.firstWhere((x) => x.label == 'unusually high libido');
    expect((libido.total, libido.withinWindow, libido.windowDays), (3, 1, 7));
    final mood = a.firstWhere((x) => x.label == 'irritable / angry mood');
    expect((mood.total, mood.withinWindow, mood.windowDays), (1, 1, 5));
  });

  test('no associations are produced without red-blood days', () async {
    await repo.saveLibido(localDate: '2026-09-10', direction: 'unusually_high');
    await repo.saveFluid(localDate: '2026-09-11', colours: ['brown']);
    expect((await compute(db)).associations, isEmpty);
  });

  test('date range limits everything consistently', () async {
    await repo.saveFluid(localDate: '2026-08-01', colours: ['brown']);
    await repo.saveFluid(localDate: '2026-09-10', colours: ['brown']);
    final i = await compute(db, from: '2026-09-01', to: '2026-09-15');
    expect(i.fluidObservationCount, 1);
    expect(i.unobservedDays, 14);
  });

  test('helpers: runsOf and longestRun', () {
    expect(runsOf(['2026-09-01', '2026-09-02', '2026-09-05']).map((r) => r.length), [2, 1]);
    expect(longestRun(['2026-12-31', '2027-01-01'])!.length, 2);
    expect(longestRun([]), isNull);
  });
}
