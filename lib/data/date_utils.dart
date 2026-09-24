import 'package:intl/intl.dart';

/// Calendar dates are plain `YYYY-MM-DD` strings in the user's local time.
///
/// We never convert through UTC, so a record made at 23:59 stays on that day.

/// Formats the calendar-date part of [d], ignoring time and zone.
String formatLocalDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Parses `YYYY-MM-DD` into a local midnight [DateTime].
DateTime parseLocalDate(String s) {
  final parts = s.split('-');
  if (parts.length != 3) throw FormatException('Bad date: $s');
  return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}

bool isValidLocalDate(String s) {
  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(s)) return false;
  try {
    return formatLocalDate(parseLocalDate(s)) == s;
  } catch (_) {
    return false;
  }
}

/// `HH:mm` for the time-of-day of [d].
String formatLocalTime(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

bool isValidLocalTime(String s) => RegExp(r'^([01]\d|2[0-3]):[0-5]\d$').hasMatch(s);

/// Adds whole calendar days without DST drift (works on y/m/d, not 24h blocks).
String addDaysToLocalDate(String date, int days) {
  final d = parseLocalDate(date);
  return formatLocalDate(DateTime(d.year, d.month, d.day + days));
}

/// Inclusive list of dates between [from] and [to].
List<String> localDateRange(String from, String to) {
  final result = <String>[];
  var cur = from;
  while (cur.compareTo(to) <= 0) {
    result.add(cur);
    cur = addDaysToLocalDate(cur, 1);
  }
  return result;
}

String prettyDate(String date) =>
    DateFormat('EEEE d MMMM yyyy').format(parseLocalDate(date));

String shortDate(String date) =>
    DateFormat('d MMM').format(parseLocalDate(date));

String monthYear(DateTime d) => DateFormat('MMMM yyyy').format(d);

/// Human description of an imprecise date (brief §43).
String describeDateEstimate(String precision, String start, String? end) {
  switch (precision) {
    case 'approximate':
      return 'About ${DateFormat('d MMM yyyy').format(parseLocalDate(start))}';
    case 'range':
      final s = parseLocalDate(start);
      final e = parseLocalDate(end ?? start);
      return '${DateFormat('d MMM yyyy').format(s)} – ${DateFormat('d MMM yyyy').format(e)}';
    case 'month_only':
      return monthYear(parseLocalDate(start));
    default:
      return DateFormat('d MMM yyyy').format(parseLocalDate(start));
  }
}
