import 'date_utils.dart';
import 'day_status.dart';

/// Recent days (before today) that have no record at all and that the user has
/// not already answered "I don't remember" for.
///
/// Days before the very first recorded date are never offered, so a new user
/// isn't nagged about a backlog. Today is excluded because it's still in progress.
List<String> missedDays({
  required String today,
  required Map<String, DaySummary> summaries,
  Set<String> skipped = const {},
  int lookbackDays = 7,
}) {
  final observed = summaries.entries
      .where((e) => e.value.status != DayStatus.unobserved)
      .map((e) => e.key)
      .toList()
    ..sort();
  if (observed.isEmpty) return const [];

  final earliestAllowed = addDaysToLocalDate(today, -lookbackDays);
  final afterFirst = addDaysToLocalDate(observed.first, 1);
  final start = earliestAllowed.compareTo(afterFirst) >= 0 ? earliestAllowed : afterFirst;
  final end = addDaysToLocalDate(today, -1);
  if (start.compareTo(end) > 0) return const [];

  return [
    for (final d in localDateRange(start, end))
      if (!(summaries[d]?.status != null &&
              summaries[d]!.status != DayStatus.unobserved) &&
          !skipped.contains(d))
        d,
  ];
}
