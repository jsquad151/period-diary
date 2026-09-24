import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:period_diary/app.dart';
import 'package:period_diary/data/database.dart';
import 'package:period_diary/data/file_gateway.dart';
import 'package:period_diary/providers.dart';

/// Pumps the whole app on an in-memory database.
Future<AppDatabase> pumpApp(WidgetTester tester,
    {AppDatabase? existing, FileGateway? gateway}) async {
  final db = existing ?? AppDatabase.memory();
  await tester.pumpWidget(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      if (gateway != null) fileGatewayProvider.overrideWithValue(gateway),
    ],
    child: const CycleTrackerApp(),
  ));
  await settle(tester);
  return db;
}

/// Lets database streams and animations complete (real async for sqlite).
Future<void> settle(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pumpAndSettle();
}

/// Tears the app down so drift's stream-cleanup timers don't outlive the test.
Future<void> disposeApp(WidgetTester tester, AppDatabase db, {bool closeDb = true}) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
  if (closeDb) await tester.runAsync(db.close);
}
