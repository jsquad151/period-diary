import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/date_utils.dart';
import '../data/entries.dart';
import 'entry_list.dart' show entryIcon;

/// Read-only summary of one entry; tapping opens its day.
class EntryTile extends StatelessWidget {
  const EntryTile({super.key, required this.entry, this.showDate = false});
  final DayEntry entry;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final head = [
      if (showDate) shortDate(entry.localDate),
      if (entry.localTime != null) entry.localTime!,
      entry.title,
    ].join('  ·  ');
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push('/day/${entry.localDate}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(entryIcon(entry.kind), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(head, style: theme.textTheme.titleSmall),
                    for (final l in entry.lines) Text(l),
                    if (entry.notes != null)
                      Text(entry.notes!,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontStyle: FontStyle.italic)),
                    if (entry.reconstructed)
                      Text('Remembered afterwards', style: theme.textTheme.bodySmall),
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
