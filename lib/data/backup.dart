import 'dart:convert';

import 'package:drift/drift.dart';

import 'database.dart';
import 'date_utils.dart';
import 'repository.dart';
import 'vocab.dart';

/// Bump when the exported JSON layout changes; importers must accept older versions.
const backupSchemaVersion = 1;

class BackupException implements Exception {
  BackupException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// What to do with rows that already exist.
enum ImportMode {
  /// Add only rows we don't already have; existing rows are never changed.
  merge,

  /// Wipe current data first, then load the file. Destructive.
  replace,
}

class TableCounts {
  TableCounts(this.total, this.existing);
  final int total;
  final int existing;
  int get added => total - existing;
}

class ImportPreview {
  ImportPreview(this.schemaVersion, this.exportedAt, this.tables);
  final int schemaVersion;
  final String? exportedAt;
  final Map<String, TableCounts> tables;

  int get totalRows => tables.values.fold(0, (a, t) => a + t.total);
  int get existingRows => tables.values.fold(0, (a, t) => a + t.existing);
  int get addedRows => totalRows - existingRows;
}

// ---------------------------------------------------------------- export

Future<Map<String, Object?>> exportBackup(AppDatabase db, {DateTime? now}) async {
  Future<List<Map<String, dynamic>>> rows<T extends DataClass>(
          Future<List<T>> query) async =>
      [for (final r in await query) r.toJson()];

  final settings = await db.select(db.settings).get();
  return {
    'schemaVersion': backupSchemaVersion,
    'exportedAt': nowStamp(now),
    'dayCheckIns': await rows(db.select(db.dayCheckIns).get()),
    'dailyNotes': await rows(db.select(db.dailyNotes).get()),
    'fluidObservations': await rows(db.select(db.fluidObservations).get()),
    'libidoEvents': await rows(db.select(db.libidoEvents).get()),
    'moodEvents': await rows(db.select(db.moodEvents).get()),
    'physicalSymptoms': await rows(db.select(db.physicalSymptoms).get()),
    'contextEvents': await rows(db.select(db.contextEvents).get()),
    'episodes': await rows(db.select(db.episodes).get()),
    'settings': {for (final s in settings) s.key: s.value},
  };
}

String encodeBackup(Map<String, Object?> backup) =>
    const JsonEncoder.withIndent('  ').convert(backup);

// ---------------------------------------------------------------- import

class _Spec {
  _Spec({
    required this.name,
    required this.parse,
    required this.key,
    required this.date,
    required this.existingKeys,
    required this.insert,
    required this.clear,
  });

  final String name;
  final Object Function(Map<String, dynamic>) parse;
  final String Function(Object) key;
  final String? Function(Object) date;
  final Future<Set<String>> Function() existingKeys;
  final Future<void> Function(Object) insert;
  final Future<void> Function() clear;
}

List<_Spec> _specs(AppDatabase db) => [
      _Spec(
        name: 'dayCheckIns',
        parse: DayCheckIn.fromJson,
        key: (r) => (r as DayCheckIn).localDate,
        date: (r) => (r as DayCheckIn).localDate,
        existingKeys: () async =>
            (await db.select(db.dayCheckIns).get()).map((r) => r.localDate).toSet(),
        insert: (r) => db.into(db.dayCheckIns).insert(r as DayCheckIn,
            mode: InsertMode.insertOrIgnore),
        clear: () => db.delete(db.dayCheckIns).go(),
      ),
      _Spec(
        name: 'dailyNotes',
        parse: DailyNote.fromJson,
        key: (r) => (r as DailyNote).localDate,
        date: (r) => (r as DailyNote).localDate,
        existingKeys: () async =>
            (await db.select(db.dailyNotes).get()).map((r) => r.localDate).toSet(),
        insert: (r) =>
            db.into(db.dailyNotes).insert(r as DailyNote, mode: InsertMode.insertOrIgnore),
        clear: () => db.delete(db.dailyNotes).go(),
      ),
      _Spec(
        name: 'fluidObservations',
        parse: FluidObservation.fromJson,
        key: (r) => (r as FluidObservation).id,
        date: (r) => (r as FluidObservation).localDate,
        existingKeys: () async =>
            (await db.select(db.fluidObservations).get()).map((r) => r.id).toSet(),
        insert: (r) => db.into(db.fluidObservations).insert(r as FluidObservation,
            mode: InsertMode.insertOrIgnore),
        clear: () => db.delete(db.fluidObservations).go(),
      ),
      _Spec(
        name: 'libidoEvents',
        parse: LibidoEvent.fromJson,
        key: (r) => (r as LibidoEvent).id,
        date: (r) => (r as LibidoEvent).localDate,
        existingKeys: () async =>
            (await db.select(db.libidoEvents).get()).map((r) => r.id).toSet(),
        insert: (r) => db.into(db.libidoEvents).insert(r as LibidoEvent,
            mode: InsertMode.insertOrIgnore),
        clear: () => db.delete(db.libidoEvents).go(),
      ),
      _Spec(
        name: 'moodEvents',
        parse: MoodEvent.fromJson,
        key: (r) => (r as MoodEvent).id,
        date: (r) => (r as MoodEvent).localDate,
        existingKeys: () async =>
            (await db.select(db.moodEvents).get()).map((r) => r.id).toSet(),
        insert: (r) =>
            db.into(db.moodEvents).insert(r as MoodEvent, mode: InsertMode.insertOrIgnore),
        clear: () => db.delete(db.moodEvents).go(),
      ),
      _Spec(
        name: 'physicalSymptoms',
        parse: PhysicalSymptom.fromJson,
        key: (r) => (r as PhysicalSymptom).id,
        date: (r) => (r as PhysicalSymptom).localDate,
        existingKeys: () async =>
            (await db.select(db.physicalSymptoms).get()).map((r) => r.id).toSet(),
        insert: (r) => db.into(db.physicalSymptoms).insert(r as PhysicalSymptom,
            mode: InsertMode.insertOrIgnore),
        clear: () => db.delete(db.physicalSymptoms).go(),
      ),
      _Spec(
        name: 'contextEvents',
        parse: ContextEvent.fromJson,
        key: (r) => (r as ContextEvent).id,
        date: (r) => (r as ContextEvent).dateStart,
        existingKeys: () async =>
            (await db.select(db.contextEvents).get()).map((r) => r.id).toSet(),
        insert: (r) => db.into(db.contextEvents).insert(r as ContextEvent,
            mode: InsertMode.insertOrIgnore),
        clear: () => db.delete(db.contextEvents).go(),
      ),
      _Spec(
        name: 'episodes',
        parse: Episode.fromJson,
        key: (r) => (r as Episode).id,
        date: (r) => (r as Episode).startDate,
        existingKeys: () async =>
            (await db.select(db.episodes).get()).map((r) => r.id).toSet(),
        insert: (r) =>
            db.into(db.episodes).insert(r as Episode, mode: InsertMode.insertOrIgnore),
        clear: () => db.delete(db.episodes).go(),
      ),
    ];

/// Parses JSON text into a backup map, or throws a readable [BackupException].
Map<String, dynamic> decodeBackup(String text) {
  final Object? decoded;
  try {
    decoded = jsonDecode(text);
  } on FormatException {
    throw BackupException('This file isn\'t valid JSON, so it can\'t be a backup.');
  }
  if (decoded is! Map<String, dynamic>) {
    throw BackupException('This file doesn\'t look like a backup from this app.');
  }
  return decoded;
}

class _Parsed {
  _Parsed(this.spec, this.rows);
  final _Spec spec;
  final List<Object> rows;
}

/// Validates the whole file up front; nothing is written until it is fully valid.
List<_Parsed> _validate(AppDatabase db, Map<String, dynamic> root) {
  final version = root['schemaVersion'];
  if (version is! int) {
    throw BackupException('This file has no schema version, so it isn\'t a backup from this app.');
  }
  if (version < 1) throw BackupException('Unsupported backup version $version.');
  if (version > backupSchemaVersion) {
    throw BackupException(
        'This backup was made by a newer version of the app (version $version). '
        'Update the app before importing it.');
  }

  final parsed = <_Parsed>[];
  for (final spec in _specs(db)) {
    final raw = root[spec.name];
    if (raw == null) {
      parsed.add(_Parsed(spec, const []));
      continue;
    }
    if (raw is! List) throw BackupException('"${spec.name}" should be a list.');
    final seen = <String>{};
    final rows = <Object>[];
    for (var i = 0; i < raw.length; i++) {
      final item = raw[i];
      try {
        if (item is! Map<String, dynamic>) throw const FormatException('not an object');
        final row = spec.parse(item);
        final d = spec.date(row);
        if (d != null && !isValidLocalDate(d)) throw FormatException('bad date "$d"');
        if (!seen.add(spec.key(row))) throw const FormatException('duplicate id');
        rows.add(row);
      } catch (e) {
        throw BackupException('Problem in ${spec.name}, entry ${i + 1}: $e');
      }
    }
    parsed.add(_Parsed(spec, rows));
  }

  final settings = root['settings'];
  if (settings != null &&
      (settings is! Map || settings.values.any((v) => v is! String))) {
    throw BackupException('"settings" should be a map of text values.');
  }
  return parsed;
}

Future<ImportPreview> previewBackup(AppDatabase db, Map<String, dynamic> root) async {
  final parsed = _validate(db, root);
  final tables = <String, TableCounts>{};
  for (final p in parsed) {
    final existing = await p.spec.existingKeys();
    tables[p.spec.name] = TableCounts(
        p.rows.length, p.rows.where((r) => existing.contains(p.spec.key(r))).length);
  }
  final settings = (root['settings'] as Map?) ?? const {};
  final existingSettings =
      (await db.select(db.settings).get()).map((s) => s.key).toSet();
  tables['settings'] = TableCounts(
      settings.length, settings.keys.where((k) => existingSettings.contains(k)).length);
  return ImportPreview(root['schemaVersion'] as int, root['exportedAt'] as String?, tables);
}

/// Applies the backup in a single transaction: all of it or none of it.
Future<void> applyBackup(
    AppDatabase db, Map<String, dynamic> root, ImportMode mode) async {
  final parsed = _validate(db, root);
  final settings = ((root['settings'] as Map?) ?? const {}).cast<String, String>();
  await db.transaction(() async {
    if (mode == ImportMode.replace) {
      for (final p in parsed) {
        await p.spec.clear();
      }
      await db.delete(db.settings).go();
    }
    for (final p in parsed) {
      for (final r in p.rows) {
        await p.spec.insert(r);
      }
    }
    for (final e in settings.entries) {
      await db.into(db.settings).insert(
          SettingsCompanion.insert(key: e.key, value: e.value),
          mode: InsertMode.insertOrIgnore);
    }
  });
}

// ------------------------------------------------------------------- CSV

String _cell(String? v) {
  var s = v ?? '';
  // Stop spreadsheets treating text as a formula.
  if (s.isNotEmpty && '=+-@'.contains(s[0])) s = "'$s";
  if (s.contains(',') || s.contains('"') || s.contains('\n') || s.contains('\r')) {
    s = '"${s.replaceAll('"', '""')}"';
  }
  return s;
}

String _csv(List<String> header, List<List<String?>> rows) =>
    [header, ...rows].map((r) => r.map(_cell).join(',')).join('\r\n');

String _labels(List<Option> options, List<String> keys) =>
    keys.map((k) => labelFor(options, k)).join('; ');

String? _label(List<Option> options, String? key) =>
    key == null ? null : labelFor(options, key);

/// One human-readable CSV per record type (brief §64).
Future<Map<String, String>> buildCsvFiles(AppDatabase db) async {
  int byDate(String a, String? at, String b, String? bt) {
    final c = a.compareTo(b);
    return c != 0 ? c : (at ?? '').compareTo(bt ?? '');
  }

  final fluids = await db.select(db.fluidObservations).get()
    ..sort((a, b) => byDate(a.localDate, a.localTime, b.localDate, b.localTime));
  final libidos = await db.select(db.libidoEvents).get()
    ..sort((a, b) => byDate(a.localDate, a.localTime, b.localDate, b.localTime));
  final moods = await db.select(db.moodEvents).get()
    ..sort((a, b) => byDate(a.localDate, a.localTime, b.localDate, b.localTime));
  final symptoms = await db.select(db.physicalSymptoms).get()
    ..sort((a, b) => byDate(a.localDate, a.localTime, b.localDate, b.localTime));
  final contexts = await db.select(db.contextEvents).get()
    ..sort((a, b) => a.dateStart.compareTo(b.dateStart));
  final checkIns = await db.select(db.dayCheckIns).get()
    ..sort((a, b) => a.localDate.compareTo(b.localDate));
  final notes = await db.select(db.dailyNotes).get()
    ..sort((a, b) => a.localDate.compareTo(b.localDate));

  return {
    'fluid-observations.csv': _csv([
      'id', 'date', 'time', 'entered', 'what_noticed', 'colours', 'amount', 'textures',
      'blood_presence', 'how_noticed', 'clot_certainty', 'clot_quantity',
      'clot_size_category', 'clot_size_mm', 'clot_appearance', 'odour', 'notes',
      'created_at', 'updated_at',
    ], [
      for (final f in fluids)
        [
          f.id, f.localDate, f.localTime, _label(_sources, f.source),
          _labels(materialTypes, f.materialTypes), _labels(fluidColours, f.colours),
          _label(fluidAmounts, f.amount), _labels(fluidTextures, f.textures),
          labelFor(bloodPresenceOptions, f.bloodPresence),
          _labels(visibilityContexts, f.visibilityContexts),
          _label(clotPresenceOptions, f.clot?.presence),
          _label(clotQuantities, f.clot?.quantity),
          _label(clotSizes, f.clot?.sizeCategory),
          f.clot?.largestApproximateSizeMm?.toString(),
          f.clot == null ? null : _labels(clotAppearances, f.clot!.appearance),
          _label(odourOptions, f.odourChange), f.notes, f.createdAt, f.updatedAt,
        ],
    ]),
    'libido-events.csv': _csv(
      ['id', 'date', 'time', 'entered', 'direction', 'notes', 'created_at', 'updated_at'],
      [
        for (final l in libidos)
          [
            l.id, l.localDate, l.localTime, _label(_sources, l.source),
            labelFor(libidoDirections, l.direction), l.notes, l.createdAt, l.updatedAt,
          ],
      ],
    ),
    'mood-events.csv': _csv(
      ['id', 'date', 'time', 'entered', 'categories', 'notes', 'created_at', 'updated_at'],
      [
        for (final m in moods)
          [
            m.id, m.localDate, m.localTime, _label(_sources, m.source),
            _labels(moodCategories, m.categories), m.notes, m.createdAt, m.updatedAt,
          ],
      ],
    ),
    'physical-symptoms.csv': _csv([
      'id', 'date', 'time', 'entered', 'symptom', 'severity_0_10', 'locations',
      'qualities', 'notes', 'created_at', 'updated_at',
    ], [
      for (final s in symptoms)
        [
          s.id, s.localDate, s.localTime, _label(_sources, s.source),
          labelFor(physicalSymptomTypes, s.symptomType), s.severity?.toString(),
          _labels(painLocations, s.locations), _labels(painQualities, s.qualities),
          s.notes, s.createdAt, s.updatedAt,
        ],
    ]),
    'context-events.csv': _csv([
      'id', 'type', 'title', 'date_precision', 'date_start', 'date_end', 'notes',
      'created_at', 'updated_at',
    ], [
      for (final c in contexts)
        [
          c.id, labelFor(contextEventTypes, c.type), c.title,
          labelFor(datePrecisions, c.datePrecision), c.dateStart, c.dateEnd, c.notes,
          c.createdAt, c.updatedAt,
        ],
    ]),
    'day-checkins.csv': _csv(
      ['date', 'status', 'confirmed_at'],
      [
        for (final c in checkIns) [c.localDate, 'Nothing notable', c.confirmedAt],
      ],
    ),
    'daily-notes.csv': _csv(
      ['date', 'note', 'updated_at'],
      [
        for (final n in notes) [n.localDate, n.body, n.updatedAt],
      ],
    ),
  };
}

const _sources = [
  Option(sourceRealtime, 'At the time'),
  Option(sourceReconstructed, 'Remembered afterwards'),
];
