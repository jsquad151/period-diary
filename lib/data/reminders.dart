import 'repository.dart';

/// Settings keys for the optional daily check-in reminder.
const reminderEnabledKey = 'reminder_enabled';
const reminderTimeKey = 'reminder_time'; // HH:mm

/// The reminder is deliberately bland ("Anything notable today?") so nothing
/// health-related shows on a lock screen, and it carries no streaks or pressure.
const reminderTitle = 'Check-in';
const reminderBody = 'Anything notable today?';

abstract class ReminderScheduler {
  /// Schedules a repeating daily reminder. Returns false if the user has not
  /// allowed notifications.
  Future<bool> enable(int hour, int minute);

  Future<void> disable();
}

/// Turns a stored time string into (hour, minute); null if malformed.
(int, int)? parseReminderTime(String? s) {
  if (s == null) return null;
  final m = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').firstMatch(s);
  if (m == null) return null;
  return (int.parse(m.group(1)!), int.parse(m.group(2)!));
}

String formatReminderTime(int hour, int minute) =>
    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

/// Re-arms the reminder on app start (harmless if already scheduled).
Future<void> restoreReminder(Repository repo, ReminderScheduler scheduler) async {
  if (await repo.getSetting(reminderEnabledKey) != '1') return;
  final t = parseReminderTime(await repo.getSetting(reminderTimeKey));
  if (t == null) return;
  await scheduler.enable(t.$1, t.$2);
}
