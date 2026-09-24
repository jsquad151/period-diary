import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/data/converters.dart';
import 'package:period_diary/data/database.dart';
import 'package:period_diary/data/day_status.dart';
import 'package:period_diary/data/entries.dart';
import 'package:period_diary/data/filter.dart';
import 'package:period_diary/data/repository.dart';
import 'package:period_diary/data/timeline.dart';

/// Builds a small realistic dataset covering the brief's example searches.
Future<({AppDatabase db, Repository repo})> seeded() async {
  final db = AppDatabase.memory();
  final repo = Repository(db);
  await repo.saveFluid(
      localDate: '2026-09-20',
      localTime: '09:00',
      colours: ['brown'],
      textures: ['watery', 'grainy'],
      amount: 'moderate',
      notes: 'Only noticed once when wiping');
  await repo.saveFluid(
      localDate: '2026-09-21',
      localTime: '10:00',
      colours: ['red'],
      bloodPresence: 'definite',
      clot: const ClotObservation(presence: 'definite', sizeCategory: '10_to_20mm'));
  await repo.saveFluid(
      localDate: '2026-09-22',
      colours: ['dark_brown'],
      textures: ['sludgy'],
      bloodPresence: 'possible',
      source: 'reconstructed');
  await repo.saveLibido(localDate: '2026-09-19', direction: 'unusually_high');
  await repo.saveLibido(localDate: '2026-09-23', direction: 'unusually_low');
  await repo.saveMood(localDate: '2026-09-21', categories: ['irritable_angry']);
  await repo.saveMood(localDate: '2026-09-22', categories: ['low_sad']);
  await repo.saveSymptom(localDate: '2026-09-21', symptomType: 'cramps', severity: 5);
  await repo.markQuiet('2026-09-18');
  await repo.markQuiet('2026-09-21'); // has events too: not "quiet"
  await repo.saveDailyNote('2026-09-23', 'Cried unexpectedly over something minor');
  return (db: db, repo: repo);
}

Future<SearchResults> run(AppDatabase db, EntryFilter f) async => applyFilter(
      f,
      fluids: await db.select(db.fluidObservations).get(),
      libidos: await db.select(db.libidoEvents).get(),
      moods: await db.select(db.moodEvents).get(),
      symptoms: await db.select(db.physicalSymptoms).get(),
      checkIns: await db.select(db.dayCheckIns).get(),
      notes: await db.select(db.dailyNotes).get(),
    );

void main() {
  late AppDatabase db;
  setUp(() async => db = (await seeded()).db);
  tearDown(() => db.close());

  test('empty filter returns every entry, newest first', () async {
    final r = await run(db, const EntryFilter());
    expect(r.entries, hasLength(8));
    final dates = r.entries.map((e) => e.localDate).toList();
    expect([...dates]..sort((a, b) => b.compareTo(a)), dates);
  });

  test('"every day I recorded watery brown material"', () async {
    final r = await run(
        db, const EntryFilter(colours: {'brown'}, textures: {'watery'}));
    expect(r.entries.map((e) => e.localDate), ['2026-09-20']);
  });

  test('"all high-libido events"', () async {
    final r = await run(db, const EntryFilter(libidoDirections: {'unusually_high'}));
    expect(r.entries.map((e) => e.localDate), ['2026-09-19']);
  });

  test('"dates where red blood and clots occurred"', () async {
    final r = await run(db,
        const EntryFilter(colours: {'red'}, bloodPresence: {'definite'}, clotPresent: true));
    expect(r.entries.map((e) => e.localDate), ['2026-09-21']);
  });

  test('clot size filter', () async {
    expect((await run(db, const EntryFilter(clotSizes: {'10_to_20mm'}))).entries, hasLength(1));
    expect((await run(db, const EntryFilter(clotSizes: {'over_50mm'}))).entries, isEmpty);
  });

  test('"every irritable/angry mood event"', () async {
    final r = await run(db, const EntryFilter(moodCategories: {'irritable_angry'}));
    expect(r.entries.single.kind, EntryKind.mood);
  });

  test('"reconstructed entries only" and real-time only', () async {
    final rec = await run(db, const EntryFilter(source: 'reconstructed'));
    expect(rec.entries.single.localDate, '2026-09-22');
    final live = await run(db, const EntryFilter(source: 'realtime'));
    expect(live.entries, hasLength(7));
  });

  test('possible blood filter', () async {
    final r = await run(db, const EntryFilter(bloodPresence: {'possible'}));
    expect(r.entries.single.localDate, '2026-09-22');
  });

  test('date range is inclusive', () async {
    final r = await run(db, const EntryFilter(from: '2026-09-21', to: '2026-09-22'));
    expect(r.entries.map((e) => e.localDate).toSet(), {'2026-09-21', '2026-09-22'});
  });

  test('kind filter: physical symptoms only', () async {
    final r = await run(db, const EntryFilter(kinds: {EntryKind.symptom}));
    expect(r.entries.single.title, 'Cramps');
  });

  test('note text search covers entry notes and daily notes', () async {
    final a = await run(db, const EntryFilter(query: 'wiping'));
    expect(a.entries.single.localDate, '2026-09-20');
    final b = await run(db, const EntryFilter(query: 'CRIED'));
    expect(b.noteHits.single.date, '2026-09-23');
  });

  test('confirmed quiet days exclude days that also have entries', () async {
    final r = await run(db, const EntryFilter(quietOnly: true));
    expect(r.quietDays, ['2026-09-18']);
  });

  test('specific filters on different kinds give the union', () async {
    final r = await run(db, const EntryFilter(
        libidoDirections: {'unusually_low'}, moodCategories: {'low_sad'}));
    expect(r.entries.map((e) => e.kind).toSet(), {EntryKind.libido, EntryKind.mood});
  });

  test('isEmpty reflects active criteria', () {
    expect(const EntryFilter().isEmpty, isTrue);
    expect(const EntryFilter(clotPresent: true).isEmpty, isFalse);
  });

  test('timeline: newest first, quiet days shown, gaps omitted', () async {
    final entries = [
      for (final r in await db.select(db.fluidObservations).get()) entryFromFluid(r),
      for (final r in await db.select(db.libidoEvents).get()) entryFromLibido(r),
    ];
    final summaries = buildDaySummaries(
      checkIns: await db.select(db.dayCheckIns).get(),
      fluids: await db.select(db.fluidObservations).get(),
      libidos: await db.select(db.libidoEvents).get(),
      notes: await db.select(db.dailyNotes).get(),
    );
    final days = buildTimeline(
      entries: entries,
      summaries: summaries,
      notes: await db.select(db.dailyNotes).get(),
    );
    final dates = days.map((d) => d.date).toList();
    expect(dates, [...dates]..sort((a, b) => b.compareTo(a)));
    expect(dates, contains('2026-09-18'));
    expect(dates, isNot(contains('2026-09-17')));
    expect(days.firstWhere((d) => d.date == '2026-09-18').status, DayStatus.confirmedQuiet);
    expect(days.firstWhere((d) => d.date == '2026-09-23').note, isNotNull);
  });
}
