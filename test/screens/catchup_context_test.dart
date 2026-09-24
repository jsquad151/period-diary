import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/data/database.dart';
import 'package:period_diary/data/date_utils.dart';
import 'package:period_diary/data/repository.dart';

import 'test_helpers.dart';

void main() {
  final today = formatLocalDate(DateTime.now());
  String ago(int n) => addDaysToLocalDate(today, -n);

  void tallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(900, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('no banner for a brand-new install', (tester) async {
    final db = await pumpApp(tester);
    expect(find.byKey(const Key('catchUpBanner')), findsNothing);
    await disposeApp(tester, db);
  });

  testWidgets('catch-up: resolve three missed days three different ways', (tester) async {
    tallScreen(tester);
    final db = AppDatabase.memory();
    final repo = Repository(db);
    // First record 4 days ago, so 3, 2 and 1 days ago are missed.
    await tester.runAsync(() => repo.markQuiet(ago(4)));
    await pumpApp(tester, existing: db);

    expect(find.textContaining("haven't checked in for 3 days"), findsOneWidget);
    await tester.tap(find.byKey(const Key('catchUpBanner')));
    await settle(tester);

    await tester.tap(find.byKey(Key('quiet-${ago(3)}')));
    await settle(tester);
    await tester.tap(find.byKey(Key('skip-${ago(2)}')));
    await settle(tester);
    expect(find.byKey(Key('quiet-${ago(3)}')), findsNothing); // resolved: buttons replaced by status
    expect(find.text('Left blank'), findsOneWidget);

    await tester.tap(find.byKey(Key('add-${ago(1)}')));
    await settle(tester);
    expect(find.text(prettyDate(ago(1))), findsOneWidget); // daily detail opened
    await tester.pageBack();
    await settle(tester);

    final checkIns = await tester.runAsync(() => db.select(db.dayCheckIns).get());
    expect(checkIns!.map((c) => c.localDate), containsAll([ago(4), ago(3)]));
    // The skipped day stays unobserved: no check-in row was created for it.
    expect(checkIns.map((c) => c.localDate), isNot(contains(ago(2))));
    await disposeApp(tester, db);
  });

  testWidgets('mark all as nothing notable', (tester) async {
    tallScreen(tester);
    final db = AppDatabase.memory();
    await tester.runAsync(() => Repository(db).markQuiet(ago(4)));
    await pumpApp(tester, existing: db);
    await tester.tap(find.byKey(const Key('catchUpBanner')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('markAllQuiet')));
    await settle(tester);
    expect(find.text('Nothing notable'), findsNWidgets(3));
    await tester.tap(find.byKey(const Key('catchUpDone')));
    await settle(tester);
    expect(find.byKey(const Key('catchUpBanner')), findsNothing);
    await disposeApp(tester, db);
  });

  testWidgets('health context event with an approximate date', (tester) async {
    tallScreen(tester);
    final db = await pumpApp(tester);
    await tester.tap(find.text('Settings'));
    await settle(tester);
    await tester.tap(find.byKey(const Key('openContext')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('addContext')));
    await settle(tester);

    await tester.tap(find.byKey(const Key('chip-ctxType-contraception_stopped')));
    await tester.pump();
    expect(find.widgetWithText(TextField, 'Contraception stopped'), findsOneWidget);
    await tester.tap(find.byKey(const Key('chip-ctxPrecision-month_only')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('save')));
    await settle(tester);

    expect(find.text('Contraception stopped'), findsWidgets);
    final rows = await tester.runAsync(() => db.select(db.contextEvents).get());
    expect(rows!.single.datePrecision, 'month_only');
    expect(rows.single.type, 'contraception_stopped');
    await disposeApp(tester, db);
  });
}
