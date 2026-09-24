import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'converters.dart';

part 'database.g.dart';

/// Columns shared by every timestamped observation/event (brief §12).
mixin EventColumns on Table {
  TextColumn get id => text()();
  TextColumn get localDate => text()(); // YYYY-MM-DD
  TextColumn get localTime => text().nullable()(); // HH:mm
  TextColumn get source => text().withDefault(const Constant('realtime'))();
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Explicit "Nothing notable today" check-ins. Day status is derived.
class DayCheckIns extends Table {
  TextColumn get localDate => text()();
  TextColumn get status => text().withDefault(const Constant('confirmed_quiet'))();
  TextColumn get confirmedAt => text()();

  @override
  Set<Column> get primaryKey => {localDate};
}

/// One free-text note per day.
class DailyNotes extends Table {
  TextColumn get localDate => text()();
  TextColumn get body => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {localDate};
}

class FluidObservations extends Table with EventColumns {
  TextColumn get materialTypes =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get colours =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get amount => text().nullable()();
  TextColumn get textures =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get bloodPresence => text().withDefault(const Constant('unknown'))();
  TextColumn get visibilityContexts =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get clot => text().map(const ClotConverter()).nullable()();
  TextColumn get odourChange => text().nullable()();
}

class LibidoEvents extends Table with EventColumns {
  TextColumn get direction => text()();
}

class MoodEvents extends Table with EventColumns {
  TextColumn get categories =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
}

class PhysicalSymptoms extends Table with EventColumns {
  TextColumn get symptomType => text()();
  IntColumn get severity => integer().nullable()(); // 0-10, pain only
  TextColumn get locations =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get qualities =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
}

/// Contextual health events with an imprecise date (brief §43-44).
class ContextEvents extends Table {
  TextColumn get id => text()();
  TextColumn get datePrecision => text().withDefault(const Constant('exact'))();
  TextColumn get dateStart => text()();
  TextColumn get dateEnd => text().nullable()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Optional, reversible grouping of observations (brief §33). Unused in V1 UI.
class Episodes extends Table {
  TextColumn get id => text()();
  TextColumn get startDate => text()();
  TextColumn get endDate => text().nullable()();
  TextColumn get observationIds =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get interpretation => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [
  DayCheckIns,
  DailyNotes,
  FluidObservations,
  LibidoEvents,
  MoodEvents,
  PhysicalSymptoms,
  ContextEvents,
  Episodes,
  Settings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Opens the on-device database file.
  factory AppDatabase.open() {
    return AppDatabase(LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'cycle_tracker.sqlite'));
      return NativeDatabase.createInBackground(file);
    }));
  }

  /// In-memory database for tests.
  factory AppDatabase.memory() => AppDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement(
              'CREATE INDEX fluid_date ON fluid_observations (local_date)');
          await customStatement(
              'CREATE INDEX libido_date ON libido_events (local_date)');
          await customStatement(
              'CREATE INDEX mood_date ON mood_events (local_date)');
          await customStatement(
              'CREATE INDEX symptom_date ON physical_symptoms (local_date)');
        },
      );
}
