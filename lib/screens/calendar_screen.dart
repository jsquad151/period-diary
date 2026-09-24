import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data/date_utils.dart';
import '../data/day_status.dart';
import '../providers.dart';
import 'catchup_screen.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focused = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final summaries = ref.watch(daySummariesProvider);
    final today = DateTime.now();
    final todayKey = formatLocalDate(today);
    final theme = Theme.of(context);

    Widget cell(DateTime day, {bool isToday = false, bool outside = false}) {
      final summary = summaries[formatLocalDate(day)];
      return DayCell(
        day: day,
        summary: summary,
        isToday: isToday,
        outside: outside,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          TextButton(
            key: const Key('goToToday'),
            onPressed: () => context.push('/day/$todayKey'),
            child: const Text('Today'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CatchUpBanner(),
              TableCalendar<void>(
                firstDay: DateTime(2000),
                lastDay: DateTime(today.year, today.month, today.day),
                focusedDay: _focused,
                startingDayOfWeek: StartingDayOfWeek.monday,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                headerStyle: const HeaderStyle(formatButtonVisible: false),
                rowHeight: 64,
                onPageChanged: (d) => setState(() => _focused = d),
                onDaySelected: (selected, _) {
                  setState(() => _focused = selected);
                  context.push('/day/${formatLocalDate(selected)}');
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (_, day, _) => cell(day),
                  todayBuilder: (_, day, _) => cell(day, isToday: true),
                  outsideBuilder: (_, day, _) => cell(day, outside: true),
                  selectedBuilder: (_, day, _) => cell(day),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: _Legend(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'A blank day means nothing was recorded, not that nothing happened.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icons for calendar markers. Meaning is carried by shape, not colour alone.
const IconData iconFluid = Icons.water_drop;
const IconData iconLibido = Icons.bolt;
const IconData iconMood = Icons.sentiment_neutral;
const IconData iconSymptom = Icons.healing;
const IconData iconNote = Icons.notes;
const IconData iconQuiet = Icons.check;

class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.day,
    required this.summary,
    this.isToday = false,
    this.outside = false,
  });

  final DateTime day;
  final DaySummary? summary;
  final bool isToday;
  final bool outside;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = summary;
    final status = s?.status ?? DayStatus.unobserved;
    final markers = <IconData>[];
    if (s != null && status == DayStatus.hasNotableEntries) {
      if (s.fluidCount > 0) markers.add(iconFluid);
      if (s.symptomCount > 0) markers.add(iconSymptom);
      if (s.libidoCount > 0) markers.add(iconLibido);
      if (s.moodCount > 0) markers.add(iconMood);
      if (s.hasNote) markers.add(iconNote);
    }
    final shown = markers.take(3).toList();
    final extra = markers.length - shown.length;
    final dim = outside ? 0.4 : 1.0;

    final label = StringBuffer(prettyDate(formatLocalDate(day)));
    switch (status) {
      case DayStatus.unobserved:
        label.write(', nothing recorded');
      case DayStatus.confirmedQuiet:
        label.write(', nothing notable');
      case DayStatus.hasNotableEntries:
        label.write(', ${s!.entryCount} notable entries');
    }

    return Semantics(
      label: label.toString(),
      button: true,
      excludeSemantics: true,
      child: Opacity(
        opacity: dim,
        child: Container(
          key: Key('day-${formatLocalDate(day)}'),
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: status == DayStatus.hasNotableEntries
                ? scheme.secondaryContainer
                : null,
            border: isToday
                ? Border.all(color: scheme.primary, width: 2)
                : Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${day.day}',
                  style: TextStyle(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal)),
              const SizedBox(height: 2),
              SizedBox(
                height: 14,
                child: status == DayStatus.confirmedQuiet
                    ? Icon(iconQuiet, size: 13, color: scheme.outline)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final i in shown)
                            Icon(i, size: 12, color: scheme.onSecondaryContainer),
                          if (extra > 0)
                            Text('+$extra', style: const TextStyle(fontSize: 10)),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    Widget item(IconData i, String t) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(i, size: 16), const SizedBox(width: 4), Text(t)],
        );
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        item(iconQuiet, 'Nothing notable'),
        item(iconFluid, 'Fluid / bleeding'),
        item(iconSymptom, 'Symptom'),
        item(iconLibido, 'Libido'),
        item(iconMood, 'Mood'),
        item(iconNote, 'Note'),
      ],
    );
  }
}
