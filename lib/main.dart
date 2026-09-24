import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/database.dart';
import 'data/local_reminders.dart';
import 'data/reminders.dart';
import 'data/repository.dart';
import 'providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase.open();
  // Re-arm the optional daily reminder after an app update; does nothing unless enabled.
  restoreReminder(Repository(db), LocalNotificationReminders()).catchError((_) {});
  runApp(ProviderScope(
    overrides: [databaseProvider.overrideWithValue(db)],
    child: const CycleTrackerApp(),
  ));
}
