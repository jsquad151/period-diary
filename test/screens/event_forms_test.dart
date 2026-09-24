import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/data/date_utils.dart';

import 'test_helpers.dart';

void main() {
  final today = formatLocalDate(DateTime.now());

  void tallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(900, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

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

  testWidgets('unusual libido can be recorded in a few taps', (tester) async {
    tallScreen(tester);
    final db = await pumpApp(tester);
    await openDay(tester, today);
    await tapKey(tester, 'addLibido');
    await settle(tester);
    expect(tester.widget<FilledButton>(find.byKey(const Key('save'))).onPressed, isNull);
    await tapKey(tester, 'chip-libido-unusually_high');
    await tapKey(tester, 'save');
    await settle(tester);
    expect(find.textContaining('Unusually high libido'), findsWidgets);
    expect(find.text('1 notable observation'), findsOneWidget);
    final rows = await tester.runAsync(() => db.select(db.libidoEvents).get());
    expect(rows!.single.direction, 'unusually_high');
    await disposeApp(tester, db);
  });

  testWidgets('mood uses broad categories and allows several', (tester) async {
    tallScreen(tester);
    final db = await pumpApp(tester);
    await openDay(tester, today);
    await tapKey(tester, 'addMood');
    await settle(tester);
    await tapKey(tester, 'chip-mood-low_sad');
    await tapKey(tester, 'chip-mood-tearful_sensitive');
    await tapKey(tester, 'save');
    await settle(tester);
    expect(find.text('Low / sad, Tearful / emotionally sensitive'), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('pain details only appear for pain symptoms', (tester) async {
    tallScreen(tester);
    final db = await pumpApp(tester);
    await openDay(tester, today);
    await tapKey(tester, 'addSymptom');
    await settle(tester);

    await tapKey(tester, 'chip-symptom-bloating');
    expect(find.byKey(const Key('chip-severity-5')), findsNothing);

    await tapKey(tester, 'chip-symptom-cramps');
    expect(find.byKey(const Key('chip-severity-5')), findsOneWidget);
    await tapKey(tester, 'chip-severity-6');
    await tapKey(tester, 'chip-painLocation-lower_abdomen');
    await tapKey(tester, 'save');
    await settle(tester);

    expect(find.textContaining('Cramps'), findsOneWidget);
    expect(find.text('Severity 6/10'), findsOneWidget);
    final row = (await tester.runAsync(() => db.select(db.physicalSymptoms).get()))!.single;
    expect(row.severity, 6);
    await disposeApp(tester, db);
  });

  testWidgets('a libido entry can be edited and deleted with undo', (tester) async {
    tallScreen(tester);
    final db = await pumpApp(tester);
    await openDay(tester, today);
    await tapKey(tester, 'addLibido');
    await settle(tester);
    await tapKey(tester, 'chip-libido-unusually_high');
    await tapKey(tester, 'save');
    await settle(tester);

    await tester.tap(find.textContaining('Unusually high libido'));
    await settle(tester);
    await tapKey(tester, 'chip-libido-unusually_low');
    await tapKey(tester, 'save');
    await settle(tester);
    expect(find.textContaining('Unusually low libido'), findsOneWidget);

    await tester.tap(find.byTooltip('Entry options'));
    await settle(tester);
    await tester.tap(find.text('Delete'));
    await settle(tester);
    await tester.tap(find.byKey(const Key('confirmDelete')));
    await settle(tester);
    expect(find.textContaining('Unusually low libido'), findsNothing);
    expect(find.text('Not checked'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await settle(tester);
    expect(find.textContaining('Unusually low libido'), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('first-prototype journey: entries, tomorrow quiet, reopen, persistence',
      (tester) async {
    tallScreen(tester);
    var db = await pumpApp(tester);
    await openDay(tester, today);

    // Two brown observations, libido and mood on the same day.
    for (var i = 0; i < 2; i++) {
      await tapKey(tester, 'addFluid');
      await settle(tester);
      await tapKey(tester, 'chip-material-brown');
      await tapKey(tester, 'chip-amount-moderate');
      await tapKey(tester, 'chip-texture-watery');
      await tapKey(tester, 'chip-texture-grainy');
      await tapKey(tester, 'save');
      await settle(tester);
    }
    await tapKey(tester, 'addLibido');
    await settle(tester);
    await tapKey(tester, 'chip-libido-unusually_high');
    await tapKey(tester, 'save');
    await settle(tester);
    await tapKey(tester, 'addMood');
    await settle(tester);
    await tapKey(tester, 'chip-mood-irritable_angry');
    await tapKey(tester, 'save');
    await settle(tester);
    expect(find.text('4 notable observations'), findsOneWidget);

    // "Tomorrow" is not selectable (future), so mark yesterday quiet instead.
    await tester.tap(find.byTooltip('Previous day'));
    await settle(tester);
    await tapKey(tester, 'nothingNotable');
    await settle(tester);
    expect(find.text('Nothing notable recorded'), findsOneWidget);

    // Close and reopen the app on the same database.
    await disposeApp(tester, db, closeDb: false);
    db = await pumpApp(tester, existing: db);
    final yesterday = addDaysToLocalDate(today, -1);
    expect(
      find.descendant(
          of: find.byKey(Key('day-$yesterday')), matching: find.byIcon(Icons.check)),
      findsOneWidget,
    );
    await openDay(tester, today);
    expect(find.text('4 notable observations'), findsOneWidget);
    expect(find.text('Irritable / angry'), findsOneWidget);
    await disposeApp(tester, db);
  });
}
