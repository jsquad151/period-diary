import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/entries.dart';
import '../providers.dart';

/// All events on [date] in the order they happened.
List<DayEntry> entriesForDate(WidgetRef ref, String date) {
  final list = <DayEntry>[
    for (final f in ref.watch(fluidsProvider).value ?? const [])
      if (f.localDate == date) entryFromFluid(f),
    for (final l in ref.watch(libidosProvider).value ?? const [])
      if (l.localDate == date) entryFromLibido(l),
    for (final m in ref.watch(moodsProvider).value ?? const [])
      if (m.localDate == date) entryFromMood(m),
    for (final s in ref.watch(symptomsProvider).value ?? const [])
      if (s.localDate == date) entryFromSymptom(s),
  ]..sort(compareEntries);
  return list;
}

String entryEditPath(DayEntry e) {
  final kind = switch (e.kind) {
    EntryKind.fluid => 'fluid',
    EntryKind.libido => 'libido',
    EntryKind.mood => 'mood',
    EntryKind.symptom => 'symptom',
  };
  return '/day/${e.localDate}/$kind?id=${e.id}';
}

IconData entryIcon(EntryKind k) => switch (k) {
      EntryKind.fluid => Icons.water_drop,
      EntryKind.libido => Icons.bolt,
      EntryKind.mood => Icons.sentiment_neutral,
      EntryKind.symptom => Icons.healing,
    };

/// Deletes [e] and returns a function that puts it back (for Undo).
Future<Future<void> Function()> deleteEntry(WidgetRef ref, DayEntry e) async {
  final repo = ref.read(repositoryProvider);
  switch (e.kind) {
    case EntryKind.fluid:
      final row = await repo.deleteFluid(e.id);
      return () async => row == null ? null : repo.restoreFluid(row);
    case EntryKind.libido:
      final row = await repo.deleteLibido(e.id);
      return () async => row == null ? null : repo.restoreLibido(row);
    case EntryKind.mood:
      final row = await repo.deleteMood(e.id);
      return () async => row == null ? null : repo.restoreMood(row);
    case EntryKind.symptom:
      final row = await repo.deleteSymptom(e.id);
      return () async => row == null ? null : repo.restoreSymptom(row);
  }
}

class EntryList extends ConsumerWidget {
  const EntryList({super.key, required this.date});
  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = entriesForDate(ref, date);
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text('Recorded today', style: Theme.of(context).textTheme.titleMedium),
        ),
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: EntryCard(entry: e),
          ),
      ],
    );
  }
}

class EntryCard extends ConsumerWidget {
  const EntryCard({super.key, required this.entry});
  final DayEntry entry;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this entry?'),
        content: const Text('You can undo this right afterwards.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
              key: const Key('confirmDelete'),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    final undo = await deleteEntry(ref, entry);
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: const Text('Entry deleted'),
        action: SnackBarAction(label: 'Undo', onPressed: () => undo()),
      ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push(entryEditPath(entry)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(entryIcon(entry.kind), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      [if (entry.localTime != null) entry.localTime!, entry.title].join('  ·  '),
                      style: theme.textTheme.titleSmall,
                    ),
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
              PopupMenuButton<String>(
                key: Key('menu-${entry.id}'),
                tooltip: 'Entry options',
                onSelected: (v) {
                  if (v == 'edit') context.push(entryEditPath(entry));
                  if (v == 'delete') _confirmDelete(context, ref);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
