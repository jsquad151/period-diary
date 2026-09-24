import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/date_utils.dart';
import '../data/day_status.dart';
import '../data/timeline.dart';
import '../data/vocab.dart';
import '../providers.dart';
import '../widgets/entry_tile.dart';

/// Chronological history, newest first. Days with no record are simply absent.
class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(timelineProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Timeline')),
      body: days.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Nothing recorded yet. Days you record will appear here.',
                    textAlign: TextAlign.center),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: days.length,
              itemBuilder: (context, i) => _DaySection(day: days[i]),
            ),
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({required this.day});
  final TimelineDay day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            key: Key('timeline-${day.date}'),
            onTap: () => context.push('/day/${day.date}'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(prettyDate(day.date).toUpperCase(),
                  style: theme.textTheme.labelLarge),
            ),
          ),
          if (day.status == DayStatus.confirmedQuiet && day.entries.isEmpty && day.note == null)
            Row(children: [
              const Icon(Icons.check, size: 18),
              const SizedBox(width: 8),
              Text('Nothing notable', style: theme.textTheme.bodyLarge),
            ]),
          for (final e in day.entries)
            Padding(padding: const EdgeInsets.only(bottom: 6), child: EntryTile(entry: e)),
          if (day.note != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.notes, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(day.note!)),
              ]),
            ),
          for (final c in day.contexts)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(children: [
                const Icon(Icons.medical_information_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                      '${c.title} (${labelFor(contextEventTypes, c.type)}, '
                      '${describeDateEstimate(c.datePrecision, c.dateStart, c.dateEnd)})'),
                ),
              ]),
            ),
        ],
      ),
    );
  }
}
