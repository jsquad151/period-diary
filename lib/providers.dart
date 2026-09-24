import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database.dart';
import 'data/day_status.dart';
import 'data/repository.dart';

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
