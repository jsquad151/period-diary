import 'database.dart';
import 'day_status.dart';
import 'entries.dart';

/// One calendar day in the timeline.
class TimelineDay {
  TimelineDay(this.date, this.status);
  final String date;
  final DayStatus status;
  final List<DayEntry> entries = [];
  final List<ContextEvent> contexts = [];
  String? note;
}

/// Newest day first. Unobserved days simply don't appear (they're gaps, not "normal").
List<TimelineDay> buildTimeline({
  required List<DayEntry> entries,
  required Map<String, DaySummary> summaries,
  Iterable<DailyNote> notes = const [],
  Iterable<ContextEvent> contexts = const [],
}) {
  final days = <String, TimelineDay>{};
  TimelineDay at(String d) => days.putIfAbsent(
      d, () => TimelineDay(d, summaries[d]?.status ?? DayStatus.unobserved));

  for (final s in summaries.values) {
    if (s.status != DayStatus.unobserved) at(s.date);
  }
  for (final e in entries) {
    at(e.localDate).entries.add(e);
  }
  for (final n in notes) {
    if (n.text_.trim().isNotEmpty) at(n.localDate).note = n.text_;
  }
  for (final c in contexts) {
    at(c.dateStart).contexts.add(c);
  }
  final list = days.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  for (final d in list) {
    d.entries.sort(compareEntries);
  }
  return list;
}
