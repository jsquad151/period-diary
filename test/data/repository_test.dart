import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/data/converters.dart';
import 'package:period_diary/data/database.dart';
import 'package:period_diary/data/day_status.dart';
import 'package:period_diary/data/repository.dart';

Future<Map<String, DaySummary>> summaries(AppDatabase db) async => buildDaySummaries(
      checkIns: await db.select(db.dayCheckIns).get(),
      fluids: await db.select(db.fluidObservations).get(),
      libidos: await db.select(db.libidoEvents).get(),
      moods: await db.select(db.moodEvents).get(),
      symptoms: await db.select(db.physicalSymptoms).get(),
      notes: await db.select(db.dailyNotes).get(),
    );

void main() {
  late AppDatabase db;
  late Repository repo;

  setUp(() {
    db = AppDatabase.memory();
    repo = Repository(db);
  });
  tearDown(() => db.close());

  group('day status', () {
    test('rule table', () {
      expect(deriveDayStatus(hasEntries: false, hasQuietCheckIn: false),
          DayStatus.unobserved);
      expect(deriveDayStatus(hasEntries: false, hasQuietCheckIn: true),
          DayStatus.confirmedQuiet);
      expect(deriveDayStatus(hasEntries: true, hasQuietCheckIn: false),
          DayStatus.hasNotableEntries);
      expect(deriveDayStatus(hasEntries: true, hasQuietCheckIn: true),
          DayStatus.hasNotableEntries);
    });

    test('a blank date is absent from summaries (unobserved, not "normal")', () async {
      expect((await summaries(db)).containsKey('2026-09-23'), isFalse);
    });

    test('Nothing notable creates confirmed_quiet', () async {
      await repo.markQuiet('2026-09-23');
      expect((await summaries(db))['2026-09-23']!.status, DayStatus.confirmedQuiet);
    });

    test('adding an event to a quiet day converts it automatically', () async {
      await repo.markQuiet('2026-09-23');
      await repo.saveLibido(localDate: '2026-09-23', direction: 'unusually_high');
      expect((await summaries(db))['2026-09-23']!.status, DayStatus.hasNotableEntries);
    });

    test('deleting the only event restores the quiet check-in', () async {
      await repo.markQuiet('2026-09-23');
      final id = await repo.saveMood(
          localDate: '2026-09-23', categories: ['irritable_angry']);
      await repo.deleteMood(id);
      expect((await summaries(db))['2026-09-23']!.status, DayStatus.confirmedQuiet);
    });

    test('a daily note counts as a recorded entry; blank note removes it', () async {
      await repo.saveDailyNote('2026-09-23', 'Odd day');
      expect((await summaries(db))['2026-09-23']!.status, DayStatus.hasNotableEntries);
      await repo.saveDailyNote('2026-09-23', '   ');
      expect((await summaries(db)).containsKey('2026-09-23'), isFalse);
    });
  });

  group('fluid observations', () {
    test('multiple observations on one date coexist', () async {
      for (final t in ['09:10', '14:30', '21:00']) {
        await repo.saveFluid(localDate: '2026-09-23', localTime: t, colours: ['brown']);
      }
      expect(await db.select(db.fluidObservations).get(), hasLength(3));
      expect((await summaries(db))['2026-09-23']!.fluidCount, 3);
    });

    test('ambiguous brown material saves with unknown blood presence', () async {
      final id = await repo.saveFluid(
        localDate: '2026-09-23',
        materialTypes: ['brown'],
        colours: ['brown'],
        amount: 'moderate',
        textures: ['watery', 'grainy'],
      );
      final row = (await repo.getFluid(id))!;
      expect(row.bloodPresence, 'unknown');
      expect(row.textures, ['watery', 'grainy']);
      expect(row.source, 'realtime');
    });

    test('red blood with clot is recorded without any period classification', () async {
      final id = await repo.saveFluid(
        localDate: '2026-09-23',
        colours: ['red'],
        bloodPresence: 'definite',
        clot: const ClotObservation(
            presence: 'definite', quantity: 'one', sizeCategory: '10_to_20mm'),
      );
      expect((await repo.getFluid(id))!.clot!.quantity, 'one');
      final s = (await summaries(db))['2026-09-23']!;
      expect(s.hasDefiniteBlood, isTrue);
      expect(s.hasClot, isTrue);
    });

    test('editing preserves createdAt and bumps updatedAt', () async {
      final id =
          await repo.saveFluid(localDate: '2026-09-23', now: DateTime(2026, 9, 23, 9));
      final first = (await repo.getFluid(id))!;
      await repo.saveFluid(
          id: id,
          localDate: '2026-09-23',
          amount: 'small',
          now: DateTime(2026, 9, 23, 10));
      final second = (await repo.getFluid(id))!;
      expect(second.createdAt, first.createdAt);
      expect(second.updatedAt, isNot(first.updatedAt));
      expect(second.amount, 'small');
    });

    test('delete returns the row so it can be restored (undo)', () async {
      final id = await repo.saveFluid(localDate: '2026-09-23', colours: ['brown']);
      final removed = (await repo.deleteFluid(id))!;
      expect(await repo.getFluid(id), isNull);
      await repo.restoreFluid(removed);
      expect((await repo.getFluid(id))!.colours, ['brown']);
    });

    test('a record at 23:59 stays on its date', () async {
      final id = await repo.saveFluid(
          localDate: '2026-09-23', localTime: '23:59', colours: ['brown']);
      final row = (await repo.getFluid(id))!;
      expect(row.localDate, '2026-09-23');
      expect(row.localTime, '23:59');
    });
  });

  test('libido, mood, symptom round-trip', () async {
    final l = await repo.saveLibido(
        localDate: '2026-09-23', direction: 'unusually_high', source: 'reconstructed');
    final m = await repo.saveMood(
        localDate: '2026-09-23', categories: ['low_sad', 'tearful_sensitive']);
    final p = await repo.saveSymptom(
        localDate: '2026-09-23',
        symptomType: 'cramps',
        severity: 6,
        locations: ['lower_abdomen'],
        qualities: ['cramping']);
    expect((await repo.getLibido(l))!.source, 'reconstructed');
    expect((await repo.getMood(m))!.categories, ['low_sad', 'tearful_sensitive']);
    expect((await repo.getSymptom(p))!.severity, 6);
    expect((await summaries(db))['2026-09-23']!.entryCount, 3);
  });

  test('settings store and retrieve', () async {
    expect(await repo.getSetting('reminder'), isNull);
    await repo.setSetting('reminder', '20:00');
    await repo.setSetting('reminder', '21:00');
    expect(await repo.getSetting('reminder'), '21:00');
  });
}
