import 'database.dart';
import 'vocab.dart';

enum EntryKind { fluid, libido, mood, symptom }

/// A display-ready description of one recorded event, used by the daily
/// detail and (later) the timeline. Purely descriptive; never interprets.
class DayEntry {
  const DayEntry({
    required this.kind,
    required this.id,
    required this.localDate,
    required this.localTime,
    required this.createdAt,
    required this.source,
    required this.title,
    required this.lines,
    this.notes,
  });

  final EntryKind kind;
  final String id;
  final String localDate;
  final String? localTime;
  final String createdAt;
  final String source;
  final String title;
  final List<String> lines;
  final String? notes;

  bool get reconstructed => source == sourceReconstructed;
}

String _labels(List<Option> options, List<String> keys) =>
    keys.map((k) => labelFor(options, k)).join(', ');

DayEntry entryFromFluid(FluidObservation f) {
  final lines = <String>[];
  if (f.materialTypes.isNotEmpty) lines.add(_labels(materialTypes, f.materialTypes));
  if (f.colours.isNotEmpty) lines.add(_labels(fluidColours, f.colours));
  final detail = <String>[
    if (f.amount != null) labelFor(fluidAmounts, f.amount!),
    if (f.textures.isNotEmpty) _labels(fluidTextures, f.textures),
  ];
  if (detail.isNotEmpty) lines.add(detail.join(' · '));
  lines.add('Blood presence: ${labelFor(bloodPresenceOptions, f.bloodPresence)}');
  final clot = f.clot;
  if (clot != null) {
    final bits = <String>[
      labelFor(clotPresenceOptions, clot.presence),
      if (clot.quantity != null) labelFor(clotQuantities, clot.quantity!),
      if (clot.largestApproximateSizeMm != null)
        '~${clot.largestApproximateSizeMm} mm'
      else if (clot.sizeCategory != null)
        labelFor(clotSizes, clot.sizeCategory!),
    ];
    lines.add('Clot: ${bits.join(', ')}');
  }
  if (f.visibilityContexts.isNotEmpty) {
    lines.add(_labels(visibilityContexts, f.visibilityContexts));
  }
  if (f.odourChange != null) {
    lines.add('Odour: ${labelFor(odourOptions, f.odourChange!)}');
  }
  return DayEntry(
    kind: EntryKind.fluid,
    id: f.id,
    localDate: f.localDate,
    localTime: f.localTime,
    createdAt: f.createdAt,
    source: f.source,
    title: 'Bleeding / discharge',
    lines: lines,
    notes: f.notes,
  );
}

DayEntry entryFromLibido(LibidoEvent l) => DayEntry(
      kind: EntryKind.libido,
      id: l.id,
      localDate: l.localDate,
      localTime: l.localTime,
      createdAt: l.createdAt,
      source: l.source,
      title: labelFor(libidoDirections, l.direction),
      lines: const [],
      notes: l.notes,
    );

DayEntry entryFromMood(MoodEvent m) => DayEntry(
      kind: EntryKind.mood,
      id: m.id,
      localDate: m.localDate,
      localTime: m.localTime,
      createdAt: m.createdAt,
      source: m.source,
      title: 'Mood',
      lines: [_labels(moodCategories, m.categories)],
      notes: m.notes,
    );

DayEntry entryFromSymptom(PhysicalSymptom s) {
  final lines = <String>[
    if (s.severity != null) 'Severity ${s.severity}/10',
    if (s.locations.isNotEmpty) _labels(painLocations, s.locations),
    if (s.qualities.isNotEmpty) _labels(painQualities, s.qualities),
  ];
  return DayEntry(
    kind: EntryKind.symptom,
    id: s.id,
    localDate: s.localDate,
    localTime: s.localTime,
    createdAt: s.createdAt,
    source: s.source,
    title: labelFor(physicalSymptomTypes, s.symptomType),
    lines: lines,
    notes: s.notes,
  );
}

/// Chronological order within a day; entries with no time sort last.
int compareEntries(DayEntry a, DayEntry b) {
  final ta = a.localTime ?? '99:99';
  final tb = b.localTime ?? '99:99';
  final c = ta.compareTo(tb);
  return c != 0 ? c : a.createdAt.compareTo(b.createdAt);
}
