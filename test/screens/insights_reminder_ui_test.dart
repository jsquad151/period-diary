import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/app.dart';
import 'package:period_diary/data/database.dart';
import 'package:period_diary/data/date_utils.dart';
import 'package:period_diary/data/reminders.dart';
import 'package:period_diary/data/repository.dart';
import 'package:period_diary/providers.dart';

import 'fake_gateway.dart';
import 'test_helpers.dart';

class _FakeScheduler implements ReminderScheduler {
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
  final today = formatLocalDate(DateTime.now());
  String ago(int n) => addDaysToLocalDate(today, -n);

  void tallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(900, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('insights: empty state, then descriptive counts and coverage', (tester) async {
    tallScreen(tester);
    var db = await pumpApp(tester);
    await tester.tap(find.text('Insights'));
    await settle(tester);
    expect(find.byKey(const Key('insightsEmpty')), findsOneWidget);
    await disposeApp(tester, db, closeDb: false);

    final repo = Repository(db);
    await tester.runAsync(() async {
      await repo.markQuiet(ago(5));
      await repo.saveFluid(localDate: ago(3), colours: ['red']);
      await repo.saveLibido(localDate: ago(4), direction: 'unusually_high');
    });
    db = await pumpApp(tester, existing: db);
    await tester.tap(find.text('Insights'));
    await settle(tester);

    expect(find.text('Days with notable observations: 2'), findsOneWidget);
    expect(find.text('Days marked "nothing notable": 1'), findsOneWidget);
    expect(find.text('Days with no record: 3'), findsOneWidget); // ago 2, 1, today
    expect(find.textContaining('1 unusually high libido event'), findsOneWidget);
    expect(find.textContaining('1 of 1 recorded unusually high libido event fell within 7 days'),
        findsOneWidget);
    expect(find.textContaining('not counted as normal'), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('insights: range chips limit the period', (tester) async {
    tallScreen(tester);
    final db = AppDatabase.memory();
    await tester.runAsync(() async {
      await Repository(db).markQuiet(ago(100));
      await Repository(db).markQuiet(ago(2));
    });
    await pumpApp(tester, existing: db);
    await tester.tap(find.text('Insights'));
    await settle(tester);
    expect(find.text('Days with no record: 99'), findsOneWidget); // ago 99..3 and 1..0 => 97+2
    await tester.tap(find.byKey(const Key('chip-insightRange-30')));
    await settle(tester);
    // last 30 days: 30 days total, 1 quiet (ago 2) -> 29 unrecorded.
    expect(find.text('Days with no record: 29'), findsOneWidget);
    await disposeApp(tester, db);
  });

  testWidgets('insights: creating a report shares a PDF', (tester) async {
    tallScreen(tester);
    final db = AppDatabase.memory();
    await tester.runAsync(() => Repository(db).saveFluid(localDate: ago(1), colours: ['brown']));
    final gw = FakeFileGateway();
    await pumpApp(tester, existing: db, gateway: gw);
    await tester.tap(find.text('Insights'));
    await settle(tester);
    await tester.tap(find.byKey(const Key('makeReport')));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 500)));
    await settle(tester);
    expect(gw.shared, hasLength(1));
    expect(gw.shared.single.single.name, matches(r'^cycle-tracker-report-.*\.pdf$'));
    expect(gw.shared.single.single.mimeType, 'application/pdf');
    expect(String.fromCharCodes(gw.shared.single.single.bytes.take(5)), '%PDF-');
    await disposeApp(tester, db);
  });

  testWidgets('reminder: off by default; enabling schedules and persists', (tester) async {
    tallScreen(tester);
    final scheduler = _FakeScheduler();
    final db = AppDatabase.memory();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        reminderSchedulerProvider.overrideWithValue(scheduler),
      ],
      child: const CycleTrackerApp(),
    ));
    await settle(tester);
    await tester.tap(find.text('Settings'));
    await settle(tester);

    expect(tester.widget<SwitchListTile>(find.byKey(const Key('reminderSwitch'))).value, isFalse);
    await tester.tap(find.byKey(const Key('reminderSwitch')));
    await settle(tester);
    expect(scheduler.enabled, [(20, 0)]);
    expect(tester.widget<SwitchListTile>(find.byKey(const Key('reminderSwitch'))).value, isTrue);
    expect(await tester.runAsync(() => Repository(db).getSetting(reminderEnabledKey)), '1');

    await tester.tap(find.byKey(const Key('reminderSwitch')));
    await settle(tester);
    expect(scheduler.disabled, 1);
    expect(await tester.runAsync(() => Repository(db).getSetting(reminderEnabledKey)), '0');
    await disposeApp(tester, db);
  });

  testWidgets('reminder: denied notification permission leaves it off', (tester) async {
    tallScreen(tester);
    final scheduler = _FakeScheduler()..allow = false;
    final db = AppDatabase.memory();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        reminderSchedulerProvider.overrideWithValue(scheduler),
      ],
      child: const CycleTrackerApp(),
    ));
    await settle(tester);
    await tester.tap(find.text('Settings'));
    await settle(tester);
    await tester.tap(find.byKey(const Key('reminderSwitch')));
    await settle(tester);
    expect(find.textContaining('turned off for this app'), findsOneWidget);
    expect(tester.widget<SwitchListTile>(find.byKey(const Key('reminderSwitch'))).value, isFalse);
    await disposeApp(tester, db);
  });
}
