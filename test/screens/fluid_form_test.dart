import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/data/date_utils.dart';

import 'test_helpers.dart';

void main() {
  final today = formatLocalDate(DateTime.now());
  final yesterday = addDaysToLocalDate(today, -1);

  Future<void> tapKey(WidgetTester tester, String key) async {
    final f = find.byKey(Key(key));
    await tester.ensureVisible(f);
    await tester.tap(f);
    await tester.pump();
  }

  Future<void> openDay(WidgetTester tester, String date) async {
    await tester.tap(find.byKey(Key('day-$date')));
    await settle(tester);
  }

  Future<void> addBrownObservation(WidgetTester tester) async {
    await tapKey(tester, 'addFluid');
    await settle(tester);
    await tapKey(tester, 'chip-material-brown');
    await tapKey(tester, 'chip-colour-brown');
    await tapKey(tester, 'chip-amount-moderate');
    await tapKey(tester, 'chip-texture-watery');
    await tapKey(tester, 'chip-texture-grainy');
    await tapKey(tester, 'save');
    await settle(tester);
  }

  testWidgets('record ambiguous brown material twice on the same day', (tester) async {
    tester.view.physicalSize = const Size(900, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = await pumpApp(tester);
    await openDay(tester, today);

    await addBrownObservation(tester);
    expect(find.text('Brown material'), findsOneWidget);
    expect(find.text('Moderate · Watery, Grainy'), findsOneWidget);
    expect(find.text('Blood presence: I don\'t know'), findsOneWidget);
    expect(find.text('1 notable observation'), findsOneWidget);

    await addBrownObservation(tester);
    expect(find.text('2 notable observations'), findsOneWidget);

    final rows = await tester.runAsync(() => db.select(db.fluidObservations).get());
    expect(rows, hasLength(2));
    expect(rows!.first.source, 'realtime');
    expect(rows.first.bloodPresence, 'unknown');
    expect(rows.first.textures, ['watery', 'grainy']);
    await disposeApp(tester, db);
  });

  testWidgets('Save is disabled until something is selected', (tester) async {
    tester.view.physicalSize = const Size(900, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = await pumpApp(tester);
    await openDay(tester, today);
    await tapKey(tester, 'addFluid');
    await settle(tester);
    expect(tester.widget<FilledButton>(find.byKey(const Key('save'))).onPressed, isNull);
    await tapKey(tester, 'chip-colour-red');
    expect(tester.widget<FilledButton>(find.byKey(const Key('save'))).onPressed, isNotNull);
    await disposeApp(tester, db);
  });

  testWidgets('choosing Clot opens clot details and saves them', (tester) async {
    tester.view.physicalSize = const Size(900, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = await pumpApp(tester);
    await openDay(tester, today);
    await tapKey(tester, 'addFluid');
    await settle(tester);
    await tapKey(tester, 'chip-material-blood');
    await tapKey(tester, 'chip-blood-definite');
    await tapKey(tester, 'chip-material-clot');
    await tapKey(tester, 'moreDetails');
    await settle(tester);
    await tapKey(tester, 'chip-clotQty-one');
    await tapKey(tester, 'chip-clotSize-10_to_20mm');
    await tapKey(tester, 'save');
    await settle(tester);

    expect(find.textContaining('Clot: Possibly a clot, One'), findsOneWidget);
    final row = (await tester.runAsync(() => db.select(db.fluidObservations).get()))!.single;
    expect(row.bloodPresence, 'definite');
    expect(row.clot!.sizeCategory, '10_to_20mm');
    await disposeApp(tester, db);
  });

  testWidgets('entries on a past date are marked as remembered afterwards',
      (tester) async {
    tester.view.physicalSize = const Size(900, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = await pumpApp(tester);
    await openDay(tester, today);
    await tester.tap(find.byTooltip('Previous day'));
    await settle(tester);
    await addBrownObservation(tester);
    expect(find.text('Remembered afterwards'), findsOneWidget);
    final row = (await tester.runAsync(() => db.select(db.fluidObservations).get()))!.single;
    expect(row.localDate, yesterday);
    expect(row.source, 'reconstructed');
    await disposeApp(tester, db);
  });

  testWidgets('edit an entry, then delete it and undo', (tester) async {
    tester.view.physicalSize = const Size(900, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = await pumpApp(tester);
    await openDay(tester, today);
    await addBrownObservation(tester);

    // Edit: change amount to Small.
    await tester.tap(find.text('Brown material'));
    await settle(tester);
    await tapKey(tester, 'chip-amount-small');
    await tapKey(tester, 'save');
    await settle(tester);
    expect(find.text('Small · Watery, Grainy'), findsOneWidget);

    // Delete with confirmation.
    await tester.tap(find.byTooltip('Entry options'));
    await settle(tester);
    await tester.tap(find.text('Delete'));
    await settle(tester);
    await tester.tap(find.byKey(const Key('confirmDelete')));
    await settle(tester);
    expect(find.text('Brown material'), findsNothing);
    expect(find.text('Entry deleted'), findsOneWidget);

    // Undo restores it.
    await tester.tap(find.text('Undo'));
    await settle(tester);
    expect(find.text('Brown material'), findsOneWidget);
    await disposeApp(tester, db);
  });
}
