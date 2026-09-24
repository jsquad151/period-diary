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
    tester.view.physicalSize = const Size(900, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<AppDatabase> seededDb(WidgetTester tester) async {
    final db = AppDatabase.memory();
    final repo = Repository(db);
    await tester.runAsync(() async {
      await repo.saveFluid(
          localDate: ago(1),
          localTime: '09:20',
          materialTypes: ['brown'],
          colours: ['brown'],
          textures: ['watery', 'grainy'],
          amount: 'moderate',
          notes: 'Only noticed when wiping');
      await repo.saveFluid(
          localDate: ago(2), colours: ['red'], bloodPresence: 'definite');
      await repo.saveLibido(localDate: ago(2), direction: 'unusually_high');
      await repo.markQuiet(ago(3));
    });
    return db;
  }

  testWidgets('timeline lists days newest first with quiet days and no gaps',
      (tester) async {
    tallScreen(tester);
    final db = await seededDb(tester);
    await pumpApp(tester, existing: db);
    await tester.tap(find.text('Timeline'));
    await settle(tester);

    expect(find.byKey(Key('timeline-${ago(1)}')), findsOneWidget);
    expect(find.byKey(Key('timeline-${ago(2)}')), findsOneWidget);
    expect(find.byKey(Key('timeline-${ago(3)}')), findsOneWidget);
    expect(find.byKey(Key('timeline-${ago(4)}')), findsNothing);
    expect(find.text('Nothing notable'), findsOneWidget);
    expect(find.text('Brown material'), findsOneWidget);

    final y1 = tester.getTopLeft(find.byKey(Key('timeline-${ago(1)}'))).dy;
    final y3 = tester.getTopLeft(find.byKey(Key('timeline-${ago(3)}'))).dy;
    expect(y1, lessThan(y3));
    await disposeApp(tester, db);
  });

  testWidgets('search: note text finds the observation', (tester) async {
    tallScreen(tester);
    final db = await seededDb(tester);
    await pumpApp(tester, existing: db);
    await tester.tap(find.text('Search'));
    await settle(tester);
    expect(find.textContaining('Search your notes'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('searchField')), 'wiping');
    await settle(tester);
    expect(find.text('1 result'), findsOneWidget);
    expect(find.text('Brown material'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('searchField')), 'zzz');
    await settle(tester);
    expect(find.byKey(const Key('noMatches')), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('search: filter by colour and by unusually high libido', (tester) async {
    tallScreen(tester);
    final db = await seededDb(tester);
    await pumpApp(tester, existing: db);
    await tester.tap(find.text('Search'));
    await settle(tester);

    await tester.tap(find.byKey(const Key('openFilters')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('chip-fcolour-brown')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('closeFilters')));
    await settle(tester);
    expect(find.text('1 result'), findsOneWidget);
    expect(find.text('Brown material'), findsOneWidget);

    await tester.tap(find.byKey(const Key('openFilters')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('clearFilters')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('chip-flibido-unusually_high')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('closeFilters')));
    await settle(tester);
    expect(find.text('1 result'), findsOneWidget);
    expect(find.textContaining('Unusually high libido'), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('search: only "Nothing notable" days', (tester) async {
    tallScreen(tester);
    final db = await seededDb(tester);
    await pumpApp(tester, existing: db);
    await tester.tap(find.text('Search'));
    await settle(tester);
    await tester.tap(find.byKey(const Key('openFilters')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('quietOnly')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('closeFilters')));
    await settle(tester);
    expect(find.text('1 result'), findsOneWidget);
    expect(find.text('Nothing notable'), findsOneWidget);
    await disposeApp(tester, db);
  });
}
