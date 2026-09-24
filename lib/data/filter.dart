import 'database.dart';
import 'entries.dart';

/// Search/filter criteria (brief §51-52).
///
/// Within one category the options are OR'd (any colour selected); different
/// categories on the same kind of entry are AND'd. Kind-specific filters
/// (fluid colour, mood category...) restrict results to that kind; if several
/// kinds have their own filters, the results are the union of each.
class EntryFilter {
  const EntryFilter({
    this.query = '',
    this.from,
    this.to,
    this.kinds = const {},
    this.source,
    this.quietOnly = false,
    // fluid
    this.colours = const {},
    this.amounts = const {},
    this.textures = const {},
    this.bloodPresence = const {},
    this.clotPresent = false,
    this.clotSizes = const {},
    // others
    this.libidoDirections = const {},
    this.moodCategories = const {},
    this.symptomTypes = const {},
  });

  final String query;
  final String? from; // inclusive YYYY-MM-DD
  final String? to; // inclusive YYYY-MM-DD
  final Set<EntryKind> kinds;
  final String? source; // realtime | reconstructed | null = both
  final bool quietOnly;

  final Set<String> colours;
  final Set<String> amounts;
  final Set<String> textures;
  final Set<String> bloodPresence;
  final bool clotPresent;
  final Set<String> clotSizes;

  final Set<String> libidoDirections;
  final Set<String> moodCategories;
  final Set<String> symptomTypes;

  bool get fluidSpecific =>
      colours.isNotEmpty ||
      amounts.isNotEmpty ||
      textures.isNotEmpty ||
      bloodPresence.isNotEmpty ||
      clotPresent ||
      clotSizes.isNotEmpty;

  bool get isEmpty =>
      query.trim().isEmpty &&
      from == null &&
      to == null &&
      kinds.isEmpty &&
      source == null &&
      !quietOnly &&
      !fluidSpecific &&
      libidoDirections.isEmpty &&
      moodCategories.isEmpty &&
      symptomTypes.isEmpty;

  EntryFilter copyWith({
    String? query,
    Object? from = _keep,
    Object? to = _keep,
    Set<EntryKind>? kinds,
    Object? source = _keep,
    bool? quietOnly,
    Set<String>? colours,
    Set<String>? amounts,
    Set<String>? textures,
    Set<String>? bloodPresence,
    bool? clotPresent,
    Set<String>? clotSizes,
    Set<String>? libidoDirections,
    Set<String>? moodCategories,
    Set<String>? symptomTypes,
  }) =>
      EntryFilter(
        query: query ?? this.query,
        from: identical(from, _keep) ? this.from : from as String?,
        to: identical(to, _keep) ? this.to : to as String?,
        kinds: kinds ?? this.kinds,
        source: identical(source, _keep) ? this.source : source as String?,
        quietOnly: quietOnly ?? this.quietOnly,
        colours: colours ?? this.colours,
        amounts: amounts ?? this.amounts,
        textures: textures ?? this.textures,
        bloodPresence: bloodPresence ?? this.bloodPresence,
        clotPresent: clotPresent ?? this.clotPresent,
        clotSizes: clotSizes ?? this.clotSizes,
        libidoDirections: libidoDirections ?? this.libidoDirections,
        moodCategories: moodCategories ?? this.moodCategories,
        symptomTypes: symptomTypes ?? this.symptomTypes,
      );
}

const Object _keep = Object();

class NoteHit {
  const NoteHit(this.date, this.text);
  final String date;
  final String text;
}

class SearchResults {
  const SearchResults({
    this.entries = const [],
    this.quietDays = const [],
    this.noteHits = const [],
  });

  /// Newest first.
  final List<DayEntry> entries;
  final List<String> quietDays;
  final List<NoteHit> noteHits;

  int get total => entries.length + quietDays.length + noteHits.length;
}

SearchResults applyFilter(
  EntryFilter f, {
  required Iterable<FluidObservation> fluids,
  required Iterable<LibidoEvent> libidos,
  required Iterable<MoodEvent> moods,
  required Iterable<PhysicalSymptom> symptoms,
  required Iterable<DayCheckIn> checkIns,
  required Iterable<DailyNote> notes,
}) {
  bool inRange(String d) =>
      (f.from == null || d.compareTo(f.from!) >= 0) &&
      (f.to == null || d.compareTo(f.to!) <= 0);
  final q = f.query.trim().toLowerCase();
  bool textOk(String? notesText) =>
      q.isEmpty || (notesText != null && notesText.toLowerCase().contains(q));
  bool sourceOk(String s) => f.source == null || f.source == s;

  // Confirmed quiet days only: a day with events or a note is not quiet.
  if (f.quietOnly) {
    final busy = <String>{
      for (final r in fluids) r.localDate,
      for (final r in libidos) r.localDate,
      for (final r in moods) r.localDate,
      for (final r in symptoms) r.localDate,
      for (final n in notes)
        if (n.body.trim().isNotEmpty) n.localDate,
    };
    final days = [
      for (final c in checkIns)
        if (inRange(c.localDate) && !busy.contains(c.localDate)) c.localDate,
    ]..sort((a, b) => b.compareTo(a));
    return SearchResults(quietDays: days);
  }

  final anySpecific = f.fluidSpecific ||
      f.libidoDirections.isNotEmpty ||
      f.moodCategories.isNotEmpty ||
      f.symptomTypes.isNotEmpty;

  bool kindWanted(EntryKind k, bool hasOwnFilter) {
    if (f.kinds.isNotEmpty && !f.kinds.contains(k)) return false;
    if (anySpecific && !hasOwnFilter) return false;
    return true;
  }

  bool overlaps(Set<String> wanted, Iterable<String> have) =>
      wanted.isEmpty || have.any(wanted.contains);

  final entries = <DayEntry>[];

  if (kindWanted(EntryKind.fluid, f.fluidSpecific)) {
    for (final r in fluids) {
      if (!inRange(r.localDate) || !sourceOk(r.source) || !textOk(r.notes)) continue;
      if (!overlaps(f.colours, r.colours)) continue;
      if (!overlaps(f.textures, r.textures)) continue;
      if (f.amounts.isNotEmpty && !f.amounts.contains(r.amount)) continue;
      if (f.bloodPresence.isNotEmpty && !f.bloodPresence.contains(r.bloodPresence)) continue;
      if (f.clotPresent && r.clot == null) continue;
      if (f.clotSizes.isNotEmpty &&
          !(r.clot != null && f.clotSizes.contains(r.clot!.sizeCategory))) {
        continue;
      }
      entries.add(entryFromFluid(r));
    }
  }
  if (kindWanted(EntryKind.libido, f.libidoDirections.isNotEmpty)) {
    for (final r in libidos) {
      if (!inRange(r.localDate) || !sourceOk(r.source) || !textOk(r.notes)) continue;
      if (f.libidoDirections.isNotEmpty && !f.libidoDirections.contains(r.direction)) continue;
      entries.add(entryFromLibido(r));
    }
  }
  if (kindWanted(EntryKind.mood, f.moodCategories.isNotEmpty)) {
    for (final r in moods) {
      if (!inRange(r.localDate) || !sourceOk(r.source) || !textOk(r.notes)) continue;
      if (!overlaps(f.moodCategories, r.categories)) continue;
      entries.add(entryFromMood(r));
    }
  }
  if (kindWanted(EntryKind.symptom, f.symptomTypes.isNotEmpty)) {
    for (final r in symptoms) {
      if (!inRange(r.localDate) || !sourceOk(r.source) || !textOk(r.notes)) continue;
      if (f.symptomTypes.isNotEmpty && !f.symptomTypes.contains(r.symptomType)) continue;
      entries.add(entryFromSymptom(r));
    }
  }
  // Newest date first; within a day, latest time first.
  entries.sort((a, b) {
    final c = b.localDate.compareTo(a.localDate);
    return c != 0 ? c : compareEntries(b, a);
  });

  // Daily notes only matter for text searches with no structural filters.
  final noteHits = <NoteHit>[];
  if (q.isNotEmpty && !anySpecific && f.kinds.isEmpty && f.source == null) {
    for (final n in notes) {
      if (inRange(n.localDate) && n.body.toLowerCase().contains(q)) {
        noteHits.add(NoteHit(n.localDate, n.body));
      }
    }
    noteHits.sort((a, b) => b.date.compareTo(a.date));
  }
  return SearchResults(entries: entries, noteHits: noteHits);
}
