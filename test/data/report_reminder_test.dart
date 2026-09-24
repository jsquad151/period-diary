import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/data/converters.dart';
import 'package:period_diary/data/database.dart';
import 'package:period_diary/data/day_status.dart';
import 'package:period_diary/data/insights.dart';
import 'package:period_diary/data/reminders.dart';
import 'package:period_diary/data/report.dart';
import 'package:period_diary/data/repository.dart';

class FakeScheduler implements ReminderScheduler {
  final List<(int, int)> enabled = [];
  int disabled = 0;
  bool allow = true;

  @override
  Future<bool> enable(int hour, int minute) async {
    if (!allow) return false;
    enabled.add((hour, minute));
    return true;
  }

  @override
  Future<void> disable() async => disabled++;
}

void main() {
  late AppDatabase db;
  late Repository repo;

  setUp(() {
    db = AppDatabase.memory();
    repo = Repository(db);
  });
  tearDown(() => db.close());

  group('report', () {
    Future<ReportData> build(String from, String to) async {
      final fluids = await db.select(db.fluidObservations).get();
      final libidos = await db.select(db.libidoEvents).get();
      final moods = await db.select(db.moodEvents).get();
      final symptoms = await db.select(db.physicalSymptoms).get();
      final cov = computeInsights(
        today: to,
        from: from,
        summaries: buildDaySummaries(
          checkIns: await db.select(db.dayCheckIns).get(),
          fluids: fluids,
          libidos: libidos,
          moods: moods,
          symptoms: symptoms,
        ),
        fluids: fluids,
        libidos: libidos,
        moods: moods,
        symptoms: symptoms,
      );
      return buildReportData(
        from: from,
        to: to,
        generatedOn: to,
        coverage: cov,
        fluids: fluids,
        libidos: libidos,
        moods: moods,
        symptoms: symptoms,
        contexts: await db.select(db.contextEvents).get(),
      );
    }

    setUp(() async {
      await repo.saveFluid(
          localDate: '2026-09-01', localTime: '09:00', colours: ['brown'],
          textures: ['watery'], notes: 'first');
      await repo.saveFluid(
          localDate: '2026-09-10', colours: ['red'], bloodPresence: 'definite',
          clot: const ClotObservation(presence: 'definite', sizeCategory: '5_to_10mm'));
      await repo.saveFluid(localDate: '2026-08-01', colours: ['brown']); // outside range
      await repo.saveSymptom(localDate: '2026-09-10', symptomType: 'cramps', severity: 6);
      await repo.saveLibido(localDate: '2026-09-09', direction: 'unusually_high');
      await repo.saveMood(localDate: '2026-09-09', categories: ['irritable_angry']);
      await repo.saveContext(
          datePrecision: 'month_only', dateStart: '2026-06-01',
          type: 'contraception_stopped', title: 'Stopped the pill');
      await repo.saveContext(
          datePrecision: 'exact', dateStart: '2025-01-01', type: 'illness', title: 'Old');
    });

    test('contains exactly what falls in the range, oldest first', () async {
      final r = await build('2026-09-01', '2026-09-30');
      expect(r.bleedingEntries.map((e) => e.localDate), ['2026-09-01', '2026-09-10']);
      expect(r.redBloodDays, ['2026-09-10']);
      expect(r.clotEntries, hasLength(1));
      expect(r.symptomEntries.single.title, 'Cramps');
      expect(r.moodLibidoEntries.map((e) => e.localDate), ['2026-09-09', '2026-09-09']);
    });

    test('context events overlapping the range are included; others are not', () async {
      final r = await build('2026-06-01', '2026-09-30');
      expect(r.contexts.map((c) => c.title), ['Stopped the pill']);
      expect((await build('2026-09-01', '2026-09-30')).contexts, isEmpty);
    });

    test('entry line is descriptive and notes what was remembered later', () async {
      final r = await build('2026-09-01', '2026-09-30');
      final line = entryLine(r.bleedingEntries.first);
      expect(line, contains('09:00'));
      expect(line, contains('Brown'));
      expect(line, contains('Note: first'));
      expect(line.toLowerCase(), isNot(contains('period')));
    });

    test('PDF renders to a valid document', () async {
      final bytes = await renderReportPdf(await build('2026-09-01', '2026-09-30'));
      expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
      expect(bytes.length, greaterThan(1000));
    });

    test('PDF still renders with no data at all', () async {
      final empty = AppDatabase.memory();
      addTearDown(empty.close);
      final data = buildReportData(
        from: '2026-09-01',
        to: '2026-09-30',
        generatedOn: '2026-09-30',
        coverage: computeInsights(
            today: '2026-09-30', summaries: {}, fluids: [], libidos: [], moods: [], symptoms: []),
        fluids: const [],
        libidos: const [],
        moods: const [],
        symptoms: const [],
        contexts: const [],
      );
      expect((await renderReportPdf(data)).length, greaterThan(500));
    });
  });

  group('reminder', () {
    test('time parsing and formatting', () {
      expect(parseReminderTime('20:05'), (20, 5));
      expect(parseReminderTime('24:00'), isNull);
      expect(parseReminderTime('8:00'), isNull);
      expect(parseReminderTime(null), isNull);
      expect(formatReminderTime(7, 5), '07:05');
    });

    test('restore does nothing when the reminder is off', () async {
      final s = FakeScheduler();
      await restoreReminder(repo, s);
      expect(s.enabled, isEmpty);
    });

    test('restore re-arms an enabled reminder at the saved time', () async {
      await repo.setSetting(reminderEnabledKey, '1');
      await repo.setSetting(reminderTimeKey, '21:30');
      final s = FakeScheduler();
      await restoreReminder(repo, s);
      expect(s.enabled, [(21, 30)]);
    });

    test('restore ignores a corrupt saved time', () async {
      await repo.setSetting(reminderEnabledKey, '1');
      await repo.setSetting(reminderTimeKey, 'soon');
      final s = FakeScheduler();
      await restoreReminder(repo, s);
      expect(s.enabled, isEmpty);
    });

    test('reminder text reveals nothing about health', () {
      final text = '$reminderTitle $reminderBody'.toLowerCase();
      for (final w in ['period', 'bleed', 'blood', 'cycle', 'symptom']) {
        expect(text, isNot(contains(w)));
      }
    });
  });
}
