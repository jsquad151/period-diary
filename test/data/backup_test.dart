import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/data/backup.dart';
import 'package:period_diary/data/converters.dart';
import 'package:period_diary/data/database.dart';
import 'package:period_diary/data/repository.dart';

Future<void> seed(Repository repo) async {
  await repo.saveFluid(
    id: 'f1',
    localDate: '2026-09-23',
    localTime: '23:59',
    materialTypes: ['brown'],
    colours: ['brown', 'dark_brown'],
    textures: ['watery', 'grainy'],
    amount: 'moderate',
    clot: const ClotObservation(
        presence: 'definite',
        quantity: 'one',
        sizeCategory: '10_to_20mm',
        largestApproximateSizeMm: 12,
        appearance: ['dark_red']),
    notes: 'Looked different, "odd", with a comma',
    now: DateTime(2026, 9, 23, 23, 59),
  );
  await repo.saveFluid(
      id: 'f2', localDate: '2026-09-24', localTime: '00:01', colours: ['red'],
      bloodPresence: 'definite', source: 'reconstructed');
  await repo.saveLibido(id: 'l1', localDate: '2026-09-23', direction: 'unusually_high');
  await repo.saveMood(id: 'm1', localDate: '2026-09-23', categories: ['low_sad', 'anxious_tense']);
  await repo.saveSymptom(
      id: 's1', localDate: '2026-09-23', symptomType: 'cramps', severity: 7,
      locations: ['lower_abdomen'], qualities: ['cramping']);
  await repo.saveContext(
      id: 'c1', datePrecision: 'month_only', dateStart: '2026-06-01',
      type: 'contraception_stopped', title: 'Stopped the pill');
  await repo.markQuiet('2026-09-22');
  await repo.saveDailyNote('2026-09-23', 'Cried over something minor');
  await repo.setSetting('reminder_time', '20:00');
}

Future<Map<String, dynamic>> snapshot(AppDatabase db) async {
  final m = await exportBackup(db, now: DateTime(2026, 1, 1));
  return jsonDecode(jsonEncode(m)) as Map<String, dynamic>;
}

void main() {
  late AppDatabase db;
  late Repository repo;

  setUp(() async {
    db = AppDatabase.memory();
    repo = Repository(db);
    await seed(repo);
  });
  tearDown(() => db.close());

  test('export carries schema version, timestamp and every table', () async {
    final b = await exportBackup(db);
    expect(b['schemaVersion'], backupSchemaVersion);
    expect(b['exportedAt'], isA<String>());
    for (final k in [
      'dayCheckIns', 'dailyNotes', 'fluidObservations', 'libidoEvents', 'moodEvents',
      'physicalSymptoms', 'contextEvents', 'episodes', 'settings',
    ]) {
      expect(b.containsKey(k), isTrue, reason: k);
    }
    expect((b['fluidObservations'] as List), hasLength(2));
  });

  test('daily note is exported as "body", not an internal name', () async {
    final b = await exportBackup(db);
    expect((b['dailyNotes'] as List).single, containsPair('body', 'Cried over something minor'));
  });

  test('lossless round trip through JSON text into an empty database', () async {
    final before = await snapshot(db);
    final text = encodeBackup(await exportBackup(db, now: DateTime(2026, 1, 1)));

    final fresh = AppDatabase.memory();
    addTearDown(fresh.close);
    final root = decodeBackup(text);
    final preview = await previewBackup(fresh, root);
    expect(preview.existingRows, 0);
    expect(preview.tables['fluidObservations']!.added, 2);
    await applyBackup(fresh, root, ImportMode.merge);

    expect(await snapshot(fresh), before);
  });

  test('dates and times are preserved exactly around midnight', () async {
    final root = decodeBackup(encodeBackup(await exportBackup(db)));
    final fresh = AppDatabase.memory();
    addTearDown(fresh.close);
    await applyBackup(fresh, root, ImportMode.merge);
    final rows = await fresh.select(fresh.fluidObservations).get();
    final f1 = rows.firstWhere((r) => r.id == 'f1');
    final f2 = rows.firstWhere((r) => r.id == 'f2');
    expect((f1.localDate, f1.localTime), ('2026-09-23', '23:59'));
    expect((f2.localDate, f2.localTime), ('2026-09-24', '00:01'));
    expect(f1.clot!.largestApproximateSizeMm, 12);
    expect(f2.source, 'reconstructed');
  });

  test('merge never overwrites existing rows and reports them', () async {
    final root = decodeBackup(encodeBackup(await exportBackup(db)));
    await repo.saveLibido(id: 'l1', localDate: '2026-09-23', direction: 'unusually_low');
    await repo.saveLibido(id: 'l-new', localDate: '2026-09-25', direction: 'uncertain');

    final preview = await previewBackup(db, root);
    expect(preview.tables['libidoEvents']!.existing, 1);

    await applyBackup(db, root, ImportMode.merge);
    final rows = await db.select(db.libidoEvents).get();
    expect(rows, hasLength(2)); // l1 kept, l-new kept, nothing duplicated
    expect(rows.firstWhere((r) => r.id == 'l1').direction, 'unusually_low');
  });

  test('replace wipes what was there and loads the file', () async {
    final root = decodeBackup(encodeBackup(await exportBackup(db)));
    await repo.saveMood(id: 'extra', localDate: '2026-09-30', categories: ['other']);
    await repo.setSetting('temp', 'x');
    await applyBackup(db, root, ImportMode.replace);
    final moods = await db.select(db.moodEvents).get();
    expect(moods.map((m) => m.id), ['m1']);
    expect(await repo.getSetting('temp'), isNull);
    expect(await repo.getSetting('reminder_time'), '20:00');
  });

  test('a bad entry rejects the whole file and changes nothing', () async {
    final good = await snapshot(db);
    final root = decodeBackup(encodeBackup(await exportBackup(db)));
    (root['libidoEvents'] as List).add({'id': 'broken'}); // missing required fields
    await expectLater(applyBackup(db, root, ImportMode.replace),
        throwsA(isA<BackupException>()));
    expect(await snapshot(db), good);
  });

  test('invalid dates and duplicate ids are rejected', () async {
    final root = decodeBackup(encodeBackup(await exportBackup(db)));
    ((root['fluidObservations'] as List).first as Map)['localDate'] = '2026-02-30';
    await expectLater(previewBackup(db, root), throwsA(isA<BackupException>()));

    final root2 = decodeBackup(encodeBackup(await exportBackup(db)));
    (root2['moodEvents'] as List).add((root2['moodEvents'] as List).first);
    await expectLater(previewBackup(db, root2), throwsA(isA<BackupException>()));
  });

  test('not-a-backup files get a readable error', () {
    expect(() => decodeBackup('not json'), throwsA(isA<BackupException>()));
    expect(() => decodeBackup('[1,2]'), throwsA(isA<BackupException>()));
  });

  test('missing or newer schema version is refused', () async {
    await expectLater(previewBackup(db, {'fluidObservations': []}),
        throwsA(isA<BackupException>()));
    await expectLater(previewBackup(db, {'schemaVersion': backupSchemaVersion + 1}),
        throwsA(predicate((e) => e.toString().contains('newer version'))));
  });

  test('older backups with missing tables still import', () async {
    await previewBackup(db, {'schemaVersion': 1, 'exportedAt': 'x'}); // no throw
  });

  test('CSV: one normalized file per type, human labels, proper escaping', () async {
    final csv = await buildCsvFiles(db);
    expect(csv.keys, containsAll([
      'fluid-observations.csv', 'mood-events.csv', 'libido-events.csv',
      'physical-symptoms.csv', 'context-events.csv', 'day-checkins.csv',
    ]));
    final fluid = csv['fluid-observations.csv']!;
    final lines = fluid.split('\r\n');
    expect(lines, hasLength(3)); // header + 2 rows
    expect(lines[1], contains('Brown; Dark brown'));
    expect(lines[1], contains('Watery; Grainy'));
    expect(lines[1], contains('"Looked different, ""odd"", with a comma"'));
    expect(csv['day-checkins.csv'], contains('2026-09-22,Nothing notable'));
  });

  test('CSV cells that look like formulas are neutralised', () async {
    await repo.saveMood(localDate: '2026-09-25', categories: ['other'], notes: '=SUM(A1)');
    final mood = (await buildCsvFiles(db))['mood-events.csv']!;
    expect(mood, contains("'=SUM(A1)"));
  });

  test('delete all removes every record and setting', () async {
    await repo.deleteAllData();
    final b = await exportBackup(db);
    for (final k in b.keys.where((k) => k != 'schemaVersion' && k != 'exportedAt')) {
      final v = b[k];
      expect(v is List ? v.isEmpty : (v as Map).isEmpty, isTrue, reason: k);
    }
  });
}
