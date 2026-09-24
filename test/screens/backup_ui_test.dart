import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/data/backup.dart';
import 'package:period_diary/data/database.dart';
import 'package:period_diary/data/repository.dart';

import 'fake_gateway.dart';
import 'test_helpers.dart';

void main() {
  void tallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(900, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<AppDatabase> openSettings(WidgetTester tester, FakeFileGateway gw,
      {AppDatabase? existing}) async {
    tallScreen(tester);
    final db = await pumpApp(tester, existing: existing, gateway: gw);
    await tester.tap(find.text('Settings'));
    await settle(tester);
    return db;
  }

  Future<AppDatabase> dbWithData(WidgetTester tester) async {
    final db = AppDatabase.memory();
    final repo = Repository(db);
    await tester.runAsync(() async {
      await repo.saveFluid(id: 'f1', localDate: '2026-09-23', colours: ['brown']);
      await repo.saveLibido(id: 'l1', localDate: '2026-09-23', direction: 'unusually_high');
      await repo.markQuiet('2026-09-22');
    });
    return db;
  }

  testWidgets('export JSON saves a file, marks the export time', (tester) async {
    final gw = FakeFileGateway();
    final db = await openSettings(tester, gw, existing: await dbWithData(tester));
    expect(find.text('Not exported yet'), findsOneWidget);

    await tester.tap(find.byKey(const Key('exportJson')));
    await settle(tester);

    expect(gw.saved, hasLength(1));
    expect(gw.saved.single.name, matches(r'^cycle-tracker-backup-\d{4}-\d{2}-\d{2}\.json$'));
    final json = jsonDecode(utf8.decode(gw.saved.single.bytes)) as Map<String, dynamic>;
    expect(json['schemaVersion'], backupSchemaVersion);
    expect((json['fluidObservations'] as List), hasLength(1));
    expect(find.text('Backup saved'), findsOneWidget);
    expect(find.textContaining('Last exported'), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('cancelling the save dialog does not record an export', (tester) async {
    final gw = FakeFileGateway()..saveCancelled = true;
    final db = await openSettings(tester, gw);
    await tester.tap(find.byKey(const Key('exportJson')));
    await settle(tester);
    expect(find.text('Not exported yet'), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('export CSV shares one file per record type', (tester) async {
    final gw = FakeFileGateway();
    final db = await openSettings(tester, gw, existing: await dbWithData(tester));
    await tester.tap(find.byKey(const Key('exportCsv')));
    await settle(tester);
    expect(gw.shared.single.map((f) => f.name),
        containsAll(['fluid-observations.csv', 'libido-events.csv', 'day-checkins.csv']));
    await disposeApp(tester, db);
  });

  testWidgets('import: preview, merge, nothing overwritten', (tester) async {
    // Make a backup from one database...
    final source = await dbWithData(tester);
    final text = (await tester.runAsync(() async => encodeBackup(await exportBackup(source))))!;

    // ...and import it into a different one that already has some overlap.
    final target = AppDatabase.memory();
    await tester.runAsync(() async {
      await Repository(target).saveLibido(
          id: 'l1', localDate: '2026-09-23', direction: 'unusually_low');
    });
    final gw = FakeFileGateway()..pickResult = text;
    final db = await openSettings(tester, gw, existing: target);

    await tester.tap(find.byKey(const Key('importJson')));
    await settle(tester);
    expect(find.byKey(const Key('importDialog')), findsOneWidget);
    expect(find.textContaining('3 records in the file: 2 new, 1 already'), findsOneWidget);

    await tester.tap(find.byKey(const Key('confirmImport')));
    await settle(tester);
    expect(find.text('Imported 2 new records'), findsOneWidget);

    final libido = (await tester.runAsync(() => db.select(db.libidoEvents).get()))!;
    expect(libido.single.direction, 'unusually_low'); // existing record untouched
    final fluid = (await tester.runAsync(() => db.select(db.fluidObservations).get()))!;
    expect(fluid, hasLength(1));
    await source.close();
    await disposeApp(tester, db);
  });

  testWidgets('import: replace needs explicit choice and wipes existing data',
      (tester) async {
    final source = await dbWithData(tester);
    final text = (await tester.runAsync(() async => encodeBackup(await exportBackup(source))))!;
    final target = AppDatabase.memory();
    await tester.runAsync(() async {
      await Repository(target).saveMood(id: 'old', localDate: '2026-01-01', categories: ['other']);
    });
    final gw = FakeFileGateway()..pickResult = text;
    final db = await openSettings(tester, gw, existing: target);

    await tester.tap(find.byKey(const Key('importJson')));
    await settle(tester);
    expect(find.text('Import'), findsOneWidget); // default is the safe merge action
    await tester.tap(find.byKey(const Key('modeReplace')));
    await settle(tester);
    expect(find.text('Replace all data'), findsOneWidget);
    await tester.tap(find.byKey(const Key('confirmImport')));
    await settle(tester);

    expect((await tester.runAsync(() => db.select(db.moodEvents).get()))!, isEmpty);
    expect((await tester.runAsync(() => db.select(db.fluidObservations).get()))!, hasLength(1));
    await source.close();
    await disposeApp(tester, db);
  });

  testWidgets('import: a file that is not a backup shows an error and changes nothing',
      (tester) async {
    final gw = FakeFileGateway()..pickResult = 'hello, not a backup';
    final db = await openSettings(tester, gw, existing: await dbWithData(tester));
    await tester.tap(find.byKey(const Key('importJson')));
    await settle(tester);
    expect(find.byKey(const Key('importError')), findsOneWidget);
    expect(find.textContaining('valid JSON'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await settle(tester);
    expect((await tester.runAsync(() => db.select(db.fluidObservations).get()))!, hasLength(1));
    await disposeApp(tester, db);
  });

  testWidgets('import: cancelling the picker does nothing', (tester) async {
    final gw = FakeFileGateway(); // pickResult null == cancelled
    final db = await openSettings(tester, gw);
    await tester.tap(find.byKey(const Key('importJson')));
    await settle(tester);
    expect(find.byKey(const Key('importDialog')), findsNothing);
    expect(find.byKey(const Key('importError')), findsNothing);
    await disposeApp(tester, db);
  });

  testWidgets('delete all needs typed confirmation; cancel keeps data', (tester) async {
    final gw = FakeFileGateway();
    final db = await openSettings(tester, gw, existing: await dbWithData(tester));

    await tester.tap(find.byKey(const Key('deleteAll')));
    await settle(tester);
    expect(tester.widget<FilledButton>(find.byKey(const Key('confirmDeleteAll'))).onPressed,
        isNull);
    await tester.tap(find.text('Cancel'));
    await settle(tester);
    expect((await tester.runAsync(() => db.select(db.fluidObservations).get()))!, hasLength(1));

    await tester.tap(find.byKey(const Key('deleteAll')));
    await settle(tester);
    await tester.enterText(find.byKey(const Key('deleteConfirmField')), 'delete');
    await tester.pump();
    await tester.tap(find.byKey(const Key('confirmDeleteAll')));
    await settle(tester);

    expect(find.text('All data deleted'), findsOneWidget);
    expect((await tester.runAsync(() => db.select(db.fluidObservations).get()))!, isEmpty);
    expect((await tester.runAsync(() => db.select(db.dayCheckIns).get()))!, isEmpty);
    await disposeApp(tester, db);
  });

  testWidgets('delete dialog can export a backup first', (tester) async {
    final gw = FakeFileGateway();
    final db = await openSettings(tester, gw, existing: await dbWithData(tester));
    await tester.tap(find.byKey(const Key('deleteAll')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('exportFirst')));
    await settle(tester);
    expect(gw.saved, hasLength(1));
    await disposeApp(tester, db);
  });
}
