import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/data/date_utils.dart';

import 'test_helpers.dart';

void main() {
  final todayKey = formatLocalDate(DateTime.now());

  testWidgets('calendar is the home screen with bottom navigation', (tester) async {
    final db = await pumpApp(tester);
    expect(find.text('Calendar'), findsWidgets);
    for (final label in ['Timeline', 'Insights', 'Search', 'Settings']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.byKey(Key('day-$todayKey')), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('tapping a date opens the daily detail as "Not checked"', (tester) async {
    final db = await pumpApp(tester);
    await tester.tap(find.byKey(Key('day-$todayKey')));
    await settle(tester);
    expect(find.text(prettyDate(todayKey)), findsOneWidget);
    expect(find.text('Not checked'), findsOneWidget);
    expect(find.byKey(const Key('nothingNotable')), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('Nothing notable today marks the day and shows a check on the calendar',
      (tester) async {
    final db = await pumpApp(tester);
    await tester.tap(find.byKey(Key('day-$todayKey')));
    await settle(tester);

    await tester.tap(find.byKey(const Key('nothingNotable')));
    await settle(tester);
    expect(find.text('Nothing notable recorded'), findsOneWidget);
    final rows = await tester.runAsync(() => db.select(db.dayCheckIns).get());
    expect(rows, hasLength(1));

    await tester.pageBack();
    await settle(tester);
    expect(
      find.descendant(
          of: find.byKey(Key('day-$todayKey')), matching: find.byIcon(Icons.check)),
      findsOneWidget,
    );
    await disposeApp(tester, db);
  });

  testWidgets('quiet mark can be removed again', (tester) async {
    final db = await pumpApp(tester);
    await tester.tap(find.byKey(Key('day-$todayKey')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('nothingNotable')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('undoQuiet')));
    await settle(tester);
    expect(find.text('Not checked'), findsOneWidget);
    final rows = await tester.runAsync(() => db.select(db.dayCheckIns).get());
    expect(rows, isEmpty);
    await disposeApp(tester, db);
  });

  testWidgets('day navigation moves to the previous day', (tester) async {
    final db = await pumpApp(tester);
    await tester.tap(find.byKey(Key('day-$todayKey')));
    await settle(tester);
    await tester.tap(find.byTooltip('Previous day'));
    await settle(tester);
    expect(find.text(prettyDate(addDaysToLocalDate(todayKey, -1))), findsOneWidget);
    await disposeApp(tester, db);
  });
}
