import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/catchup.dart';
import 'data/database.dart';
import 'data/date_utils.dart';
import 'data/day_status.dart';
import 'data/entries.dart';
import 'data/file_gateway.dart';
import 'data/local_reminders.dart';
import 'data/reminders.dart';
import 'data/repository.dart';
import 'data/timeline.dart';

/// Overridden in main() (real file) and in tests (in-memory).
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden');
});

final repositoryProvider =
    Provider<Repository>((ref) => Repository(ref.watch(databaseProvider)));

final checkInsProvider = StreamProvider<List<DayCheckIn>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.dayCheckIns).watch();
});

final dailyNotesProvider = StreamProvider<List<DailyNote>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.dailyNotes).watch();
});

final fluidsProvider = StreamProvider<List<FluidObservation>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.fluidObservations).watch();
});

final libidosProvider = StreamProvider<List<LibidoEvent>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.libidoEvents).watch();
});

final moodsProvider = StreamProvider<List<MoodEvent>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.moodEvents).watch();
});

final symptomsProvider = StreamProvider<List<PhysicalSymptom>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.physicalSymptoms).watch();
});

final contextEventsProvider = StreamProvider<List<ContextEvent>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.contextEvents).watch();
});

/// Per-date summary used by the calendar and timeline.
final daySummariesProvider = Provider<Map<String, DaySummary>>((ref) {
  return buildDaySummaries(
    checkIns: ref.watch(checkInsProvider).value ?? const [],
    fluids: ref.watch(fluidsProvider).value ?? const [],
    libidos: ref.watch(libidosProvider).value ?? const [],
    moods: ref.watch(moodsProvider).value ?? const [],
    symptoms: ref.watch(symptomsProvider).value ?? const [],
    notes: ref.watch(dailyNotesProvider).value ?? const [],
  );
});

final settingsProvider = StreamProvider<List<Setting>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.settings).watch();
});

/// Dates the user answered "I don't remember" to; they stay blank but aren't re-asked.
final skippedCatchupProvider = Provider<Set<String>>((ref) {
  final rows = ref.watch(settingsProvider).value ?? const [];
  for (final r in rows) {
    if (r.key == Repository.skippedCatchupKey) return Repository.decodeSkipped(r.value);
  }
  return <String>{};
});

/// Recent unrecorded days offered to the catch-up flow.
final missedDaysProvider = Provider<List<String>>((ref) {
  return missedDays(
    today: formatLocalDate(DateTime.now()),
    summaries: ref.watch(daySummariesProvider),
    skipped: ref.watch(skippedCatchupProvider),
  );
});

/// Every recorded event as a display-ready entry.
final allEntriesProvider = Provider<List<DayEntry>>((ref) => [
      for (final f in ref.watch(fluidsProvider).value ?? const []) entryFromFluid(f),
      for (final l in ref.watch(libidosProvider).value ?? const []) entryFromLibido(l),
      for (final m in ref.watch(moodsProvider).value ?? const []) entryFromMood(m),
      for (final s in ref.watch(symptomsProvider).value ?? const []) entryFromSymptom(s),
    ]);

final timelineProvider = Provider<List<TimelineDay>>((ref) => buildTimeline(
      entries: ref.watch(allEntriesProvider),
      summaries: ref.watch(daySummariesProvider),
      notes: ref.watch(dailyNotesProvider).value ?? const [],
      contexts: ref.watch(contextEventsProvider).value ?? const [],
    ));

/// Real file pickers in the app; replaced by a fake in tests.
final fileGatewayProvider = Provider<FileGateway>((ref) => const PluginFileGateway());

/// ISO timestamp of the last successful JSON export, if any.
final lastExportProvider = Provider<String?>((ref) {
  for (final r in ref.watch(settingsProvider).value ?? const <Setting>[]) {
    if (r.key == Repository.lastExportKey) return r.value;
  }
  return null;
});

/// Real notifications in the app; replaced by a fake in tests.
final reminderSchedulerProvider =
    Provider<ReminderScheduler>((ref) => LocalNotificationReminders());

/// (enabled, HH:mm) of the daily reminder.
final reminderSettingProvider = Provider<({bool enabled, String time})>((ref) {
  var enabled = false;
  var time = '20:00';
  for (final r in ref.watch(settingsProvider).value ?? const <Setting>[]) {
    if (r.key == reminderEnabledKey) enabled = r.value == '1';
    if (r.key == reminderTimeKey && parseReminderTime(r.value) != null) time = r.value;
  }
  return (enabled: enabled, time: time);
});
