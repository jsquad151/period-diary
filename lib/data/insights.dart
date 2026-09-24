import 'database.dart';
import 'date_utils.dart';
import 'day_status.dart';

/// Colours we treat as "brown material" / "red blood" for descriptive counts.
/// These are groupings of what the user selected, never a claim about what it was.
const brownColours = {'light_brown', 'brown', 'dark_brown', 'red_brown', 'near_black'};
const redColours = {'bright_red', 'red', 'dark_red'};

class DateRun {
  const DateRun(this.start, this.end);
  final String start;
  final String end;
  int get length => localDateRange(start, end).length;
}

class Association {
  const Association({
    required this.label,
    required this.total,
    required this.withinWindow,
    required this.windowDays,
  });

  /// e.g. "unusually high libido"
  final String label;
  final int total;

  /// How many of [total] fell within [windowDays] days up to and including
  /// a day with red blood.
  final int withinWindow;
  final int windowDays;
}

class Insights {
  const Insights({
    required this.from,
    required this.to,
    required this.confirmedQuietDays,
    required this.notableDays,
    required this.unobservedDays,
    required this.fluidObservationCount,
    required this.daysWithFluid,
    required this.highLibido,
    required this.lowLibido,
    required this.moodCounts,
    required this.symptomCounts,
    required this.longestBrownRun,
    required this.shortestGapBetweenRedRuns,
    required this.associations,
  });

  /// Inclusive tracked period (null when nothing has been recorded).
  final String? from;
  final String? to;
  final int confirmedQuietDays;
  final int notableDays;
  final int unobservedDays;
  final int fluidObservationCount;
  final int daysWithFluid;
  final int highLibido;
  final int lowLibido;
  final Map<String, int> moodCounts; // category key -> events
  final Map<String, int> symptomCounts; // symptom key -> events
  final DateRun? longestBrownRun;

  /// Days between the end of one run of red-blood days and the start of the next.
  final int? shortestGapBetweenRedRuns;
  final List<Association> associations;

  bool get isEmpty => from == null;
}

/// Longest streak of consecutive calendar days in [dates].
DateRun? longestRun(Iterable<String> dates) {
  final sorted = dates.toSet().toList()..sort();
  if (sorted.isEmpty) return null;
  var best = DateRun(sorted.first, sorted.first);
  var runStart = sorted.first;
  var prev = sorted.first;
  for (final d in sorted.skip(1)) {
    if (d == addDaysToLocalDate(prev, 1)) {
      prev = d;
    } else {
      runStart = d;
      prev = d;
    }
    final cur = DateRun(runStart, prev);
    if (cur.length > best.length) best = cur;
  }
  return best;
}

/// Splits dates into runs of consecutive days.
List<DateRun> runsOf(Iterable<String> dates) {
  final sorted = dates.toSet().toList()..sort();
  final runs = <DateRun>[];
  String? start;
  String? prev;
  for (final d in sorted) {
    if (prev != null && d == addDaysToLocalDate(prev, 1)) {
      prev = d;
      continue;
    }
    if (start != null) runs.add(DateRun(start, prev!));
    start = d;
    prev = d;
  }
  if (start != null) runs.add(DateRun(start, prev!));
  return runs;
}

int daysBetween(String a, String b) =>
    localDateRange(a.compareTo(b) <= 0 ? a : b, a.compareTo(b) <= 0 ? b : a).length - 1;

/// Descriptive statistics over [from]..[to] (inclusive; defaults to the whole
/// recorded history up to [today]). Unobserved days are counted as missing data,
/// never as "normal".
Insights computeInsights({
  required String today,
  String? from,
  String? to,
  required Map<String, DaySummary> summaries,
  required Iterable<FluidObservation> fluids,
  required Iterable<LibidoEvent> libidos,
  required Iterable<MoodEvent> moods,
  required Iterable<PhysicalSymptom> symptoms,
}) {
  final observedDates = summaries.entries
      .where((e) => e.value.status != DayStatus.unobserved)
      .map((e) => e.key)
      .toList()
    ..sort();
  final start = from ?? (observedDates.isEmpty ? null : observedDates.first);
  final end = to ?? today;

  bool inRange(String d) => start != null && d.compareTo(start) >= 0 && d.compareTo(end) <= 0;

  if (start == null || start.compareTo(end) > 0) {
    return const Insights(
      from: null, to: null, confirmedQuietDays: 0, notableDays: 0, unobservedDays: 0,
      fluidObservationCount: 0, daysWithFluid: 0, highLibido: 0, lowLibido: 0,
      moodCounts: {}, symptomCounts: {}, longestBrownRun: null,
      shortestGapBetweenRedRuns: null, associations: [],
    );
  }

  var quiet = 0, notable = 0, unobserved = 0;
  for (final d in localDateRange(start, end)) {
    switch (summaries[d]?.status ?? DayStatus.unobserved) {
      case DayStatus.confirmedQuiet:
        quiet++;
      case DayStatus.hasNotableEntries:
        notable++;
      case DayStatus.unobserved:
        unobserved++;
    }
  }

  final fl = fluids.where((f) => inRange(f.localDate)).toList();
  final li = libidos.where((l) => inRange(l.localDate)).toList();
  final mo = moods.where((m) => inRange(m.localDate)).toList();
  final sy = symptoms.where((s) => inRange(s.localDate)).toList();

  final moodCounts = <String, int>{};
  for (final m in mo) {
    for (final c in m.categories) {
      moodCounts[c] = (moodCounts[c] ?? 0) + 1;
    }
  }
  final symptomCounts = <String, int>{};
  for (final s in sy) {
    symptomCounts[s.symptomType] = (symptomCounts[s.symptomType] ?? 0) + 1;
  }

  final brownDates = <String>{
    for (final f in fl)
      if (f.materialTypes.contains('brown') || f.colours.any(brownColours.contains))
        f.localDate,
  };
  final redDates = <String>{
    for (final f in fl)
      if (f.colours.any(redColours.contains)) f.localDate,
  };

  int? shortestGap;
  final redRuns = runsOf(redDates);
  for (var i = 1; i < redRuns.length; i++) {
    final gap = daysBetween(redRuns[i - 1].end, redRuns[i].start);
    if (shortestGap == null || gap < shortestGap) shortestGap = gap;
  }

  // Descriptive, non-causal: how many events fell within N days up to and
  // including a day with red blood.
  bool nearRed(String d, int window) => redDates.any((r) {
        final diff = daysBetween(d, r);
        return r.compareTo(d) >= 0 && diff <= window;
      });

  final highDates = [for (final l in li) if (l.direction == 'unusually_high') l.localDate];
  final irritableDates = [
    for (final m in mo)
      if (m.categories.contains('irritable_angry')) m.localDate
  ];
  final associations = <Association>[
    if (redDates.isNotEmpty && highDates.isNotEmpty)
      Association(
        label: 'unusually high libido',
        total: highDates.length,
        withinWindow: highDates.where((d) => nearRed(d, 7)).length,
        windowDays: 7,
      ),
    if (redDates.isNotEmpty && irritableDates.isNotEmpty)
      Association(
        label: 'irritable / angry mood',
        total: irritableDates.length,
        withinWindow: irritableDates.where((d) => nearRed(d, 5)).length,
        windowDays: 5,
      ),
  ];

  return Insights(
    from: start,
    to: end,
    confirmedQuietDays: quiet,
    notableDays: notable,
    unobservedDays: unobserved,
    fluidObservationCount: fl.length,
    daysWithFluid: fl.map((f) => f.localDate).toSet().length,
    highLibido: highDates.length,
    lowLibido: li.where((l) => l.direction == 'unusually_low').length,
    moodCounts: moodCounts,
    symptomCounts: symptomCounts,
    longestBrownRun: longestRun(brownDates),
    shortestGapBetweenRedRuns: shortestGap,
    associations: associations,
  );
}
