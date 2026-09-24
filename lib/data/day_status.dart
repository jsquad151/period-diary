import 'database.dart';

/// Brief §13: a day is unobserved, explicitly quiet, or has notable entries.
///
/// "unobserved" means *nothing was recorded* — never "nothing happened".
enum DayStatus { unobserved, confirmedQuiet, hasNotableEntries }

/// Pure derivation rule (brief §69). Events win over a quiet check-in; the
/// check-in row is kept so that deleting a mistaken event restores the quiet day.
DayStatus deriveDayStatus({required bool hasEntries, required bool hasQuietCheckIn}) {
  if (hasEntries) return DayStatus.hasNotableEntries;
  if (hasQuietCheckIn) return DayStatus.confirmedQuiet;
  return DayStatus.unobserved;
}

/// Everything the calendar/timeline needs to know about one date.
class DaySummary {
  DaySummary(this.date);

  final String date;
  int fluidCount = 0;
  int libidoCount = 0;
  int moodCount = 0;
  int symptomCount = 0;
  bool hasNote = false;
  bool hasQuietCheckIn = false;
  bool hasDefiniteBlood = false;
  bool hasClot = false;

  int get entryCount => fluidCount + libidoCount + moodCount + symptomCount;

  DayStatus get status => deriveDayStatus(
        hasEntries: entryCount > 0 || hasNote,
        hasQuietCheckIn: hasQuietCheckIn,
      );
}

/// Builds a per-date summary from raw rows. Dates with no data are absent
/// from the map, i.e. unobserved.
Map<String, DaySummary> buildDaySummaries({
  Iterable<DayCheckIn> checkIns = const [],
  Iterable<FluidObservation> fluids = const [],
  Iterable<LibidoEvent> libidos = const [],
  Iterable<MoodEvent> moods = const [],
  Iterable<PhysicalSymptom> symptoms = const [],
  Iterable<DailyNote> notes = const [],
}) {
  final map = <String, DaySummary>{};
  DaySummary at(String d) => map.putIfAbsent(d, () => DaySummary(d));

  for (final c in checkIns) {
    at(c.localDate).hasQuietCheckIn = true;
  }
  for (final f in fluids) {
    final s = at(f.localDate);
    s.fluidCount++;
    if (f.bloodPresence == 'definite') s.hasDefiniteBlood = true;
    if (f.clot != null) s.hasClot = true;
  }
  for (final l in libidos) {
    at(l.localDate).libidoCount++;
  }
  for (final m in moods) {
    at(m.localDate).moodCount++;
  }
  for (final s in symptoms) {
    at(s.localDate).symptomCount++;
  }
  for (final n in notes) {
    if (n.text_.trim().isNotEmpty) at(n.localDate).hasNote = true;
  }
  return map;
}
