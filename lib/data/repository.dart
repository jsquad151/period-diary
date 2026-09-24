import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'converters.dart';
import 'database.dart';

const _uuid = Uuid();

String newId() => _uuid.v4();

/// ISO-8601 timestamp with the local UTC offset, e.g. 2026-09-23T20:00:00+02:00.
String nowStamp([DateTime? now]) {
  final t = (now ?? DateTime.now()).toLocal();
  final off = t.timeZoneOffset;
  final sign = off.isNegative ? '-' : '+';
  final abs = off.abs();
  final hh = abs.inHours.toString().padLeft(2, '0');
  final mm = (abs.inMinutes % 60).toString().padLeft(2, '0');
  final base = t.toIso8601String().split('.').first;
  return '$base$sign$hh:$mm';
}

/// All reads/writes go through here so UI code never touches SQL.
class Repository {
  Repository(this.db);
  final AppDatabase db;

  // ---- Day check-ins ("Nothing notable today") ----

  Future<void> markQuiet(String date, {DateTime? now}) =>
      db.into(db.dayCheckIns).insertOnConflictUpdate(DayCheckInsCompanion.insert(
            localDate: date,
            confirmedAt: nowStamp(now),
          ));

  Future<void> clearQuiet(String date) =>
      (db.delete(db.dayCheckIns)..where((t) => t.localDate.equals(date))).go();

  /// Marks several dates quiet in one go (catch-up flow).
  Future<void> markQuietMany(Iterable<String> dates, {DateTime? now}) =>
      db.transaction(() async {
        for (final d in dates) {
          await markQuiet(d, now: now);
        }
      });

  // ---- Daily note ----

  Future<void> saveDailyNote(String date, String text) async {
    if (text.trim().isEmpty) {
      await (db.delete(db.dailyNotes)..where((t) => t.localDate.equals(date))).go();
      return;
    }
    await db.into(db.dailyNotes).insertOnConflictUpdate(DailyNotesCompanion.insert(
          localDate: date,
          text_: text.trim(),
          updatedAt: nowStamp(),
        ));
  }

  // ---- Fluid observations ----

  Future<String> saveFluid({
    String? id,
    required String localDate,
    String? localTime,
    String source = 'realtime',
    List<String> materialTypes = const [],
    List<String> colours = const [],
    String? amount,
    List<String> textures = const [],
    String bloodPresence = 'unknown',
    List<String> visibilityContexts = const [],
    ClotObservation? clot,
    String? odourChange,
    String? notes,
    DateTime? now,
  }) async {
    final stamp = nowStamp(now);
    final existing = id == null ? null : await getFluid(id);
    final rowId = id ?? newId();
    await db.into(db.fluidObservations).insertOnConflictUpdate(
          FluidObservationsCompanion(
            id: Value(rowId),
            localDate: Value(localDate),
            localTime: Value(localTime),
            source: Value(source),
            materialTypes: Value(materialTypes),
            colours: Value(colours),
            amount: Value(amount),
            textures: Value(textures),
            bloodPresence: Value(bloodPresence),
            visibilityContexts: Value(visibilityContexts),
            clot: Value(clot),
            odourChange: Value(odourChange),
            notes: Value(_blankToNull(notes)),
            createdAt: Value(existing?.createdAt ?? stamp),
            updatedAt: Value(stamp),
          ),
        );
    return rowId;
  }

  Future<FluidObservation?> getFluid(String id) =>
      (db.select(db.fluidObservations)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Deletes and returns the removed row so the UI can offer Undo.
  Future<FluidObservation?> deleteFluid(String id) async {
    final row = await getFluid(id);
    await (db.delete(db.fluidObservations)..where((t) => t.id.equals(id))).go();
    return row;
  }

  Future<void> restoreFluid(FluidObservation row) =>
      db.into(db.fluidObservations).insertOnConflictUpdate(row);

  // ---- Libido ----

  Future<String> saveLibido({
    String? id,
    required String localDate,
    String? localTime,
    String source = 'realtime',
    required String direction,
    String? notes,
    DateTime? now,
  }) async {
    final stamp = nowStamp(now);
    final existing = id == null ? null : await getLibido(id);
    final rowId = id ?? newId();
    await db.into(db.libidoEvents).insertOnConflictUpdate(LibidoEventsCompanion(
          id: Value(rowId),
          localDate: Value(localDate),
          localTime: Value(localTime),
          source: Value(source),
          direction: Value(direction),
          notes: Value(_blankToNull(notes)),
          createdAt: Value(existing?.createdAt ?? stamp),
          updatedAt: Value(stamp),
        ));
    return rowId;
  }

  Future<LibidoEvent?> getLibido(String id) =>
      (db.select(db.libidoEvents)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<LibidoEvent?> deleteLibido(String id) async {
    final row = await getLibido(id);
    await (db.delete(db.libidoEvents)..where((t) => t.id.equals(id))).go();
    return row;
  }

  Future<void> restoreLibido(LibidoEvent row) =>
      db.into(db.libidoEvents).insertOnConflictUpdate(row);

  // ---- Mood ----

  Future<String> saveMood({
    String? id,
    required String localDate,
    String? localTime,
    String source = 'realtime',
    required List<String> categories,
    String? notes,
    DateTime? now,
  }) async {
    final stamp = nowStamp(now);
    final existing = id == null ? null : await getMood(id);
    final rowId = id ?? newId();
    await db.into(db.moodEvents).insertOnConflictUpdate(MoodEventsCompanion(
          id: Value(rowId),
          localDate: Value(localDate),
          localTime: Value(localTime),
          source: Value(source),
          categories: Value(categories),
          notes: Value(_blankToNull(notes)),
          createdAt: Value(existing?.createdAt ?? stamp),
          updatedAt: Value(stamp),
        ));
    return rowId;
  }

  Future<MoodEvent?> getMood(String id) =>
      (db.select(db.moodEvents)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<MoodEvent?> deleteMood(String id) async {
    final row = await getMood(id);
    await (db.delete(db.moodEvents)..where((t) => t.id.equals(id))).go();
    return row;
  }

  Future<void> restoreMood(MoodEvent row) =>
      db.into(db.moodEvents).insertOnConflictUpdate(row);

  // ---- Physical symptoms ----

  Future<String> saveSymptom({
    String? id,
    required String localDate,
    String? localTime,
    String source = 'realtime',
    required String symptomType,
    int? severity,
    List<String> locations = const [],
    List<String> qualities = const [],
    String? notes,
    DateTime? now,
  }) async {
    final stamp = nowStamp(now);
    final existing = id == null ? null : await getSymptom(id);
    final rowId = id ?? newId();
    await db.into(db.physicalSymptoms).insertOnConflictUpdate(PhysicalSymptomsCompanion(
          id: Value(rowId),
          localDate: Value(localDate),
          localTime: Value(localTime),
          source: Value(source),
          symptomType: Value(symptomType),
          severity: Value(severity),
          locations: Value(locations),
          qualities: Value(qualities),
          notes: Value(_blankToNull(notes)),
          createdAt: Value(existing?.createdAt ?? stamp),
          updatedAt: Value(stamp),
        ));
    return rowId;
  }

  Future<PhysicalSymptom?> getSymptom(String id) =>
      (db.select(db.physicalSymptoms)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<PhysicalSymptom?> deleteSymptom(String id) async {
    final row = await getSymptom(id);
    await (db.delete(db.physicalSymptoms)..where((t) => t.id.equals(id))).go();
    return row;
  }

  Future<void> restoreSymptom(PhysicalSymptom row) =>
      db.into(db.physicalSymptoms).insertOnConflictUpdate(row);

  // ---- Settings ----

  Future<String?> getSetting(String key) async {
    final row = await (db.select(db.settings)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) => db
      .into(db.settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));

  String? _blankToNull(String? s) =>
      (s == null || s.trim().isEmpty) ? null : s.trim();
}
