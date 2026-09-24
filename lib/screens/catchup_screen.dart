import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/date_utils.dart';
import '../data/day_status.dart';
import '../providers.dart';

/// Low-pressure catch-up for recent days with no record. Nothing is forced:
/// "I don't remember" leaves the day blank (unobserved).
class CatchUpScreen extends ConsumerStatefulWidget {
  const CatchUpScreen({super.key});

  @override
  ConsumerState<CatchUpScreen> createState() => _CatchUpScreenState();
}

class _CatchUpScreenState extends ConsumerState<CatchUpScreen> {
  // Fixed at open so rows don't vanish as they're resolved.
  late final List<String> _days = ref.read(missedDaysProvider);

  @override
  Widget build(BuildContext context) {
    final summaries = ref.watch(daySummariesProvider);
    final skipped = ref.watch(skippedCatchupProvider);
    final repo = ref.read(repositoryProvider);

    bool pending(String d) =>
        (summaries[d]?.status ?? DayStatus.unobserved) == DayStatus.unobserved &&
        !skipped.contains(d);
    final remaining = _days.where(pending).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Catch up')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton(
            key: const Key('catchUpDone'),
            onPressed: () => context.pop(),
            child: const Text('Done'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Anything notable happen on these days? '
            'You never have to reconstruct what you don\'t remember.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          if (remaining.length > 1)
            OutlinedButton.icon(
              key: const Key('markAllQuiet'),
              icon: const Icon(Icons.done_all),
              label: const Text('Mark all as nothing notable'),
              onPressed: () => repo.markQuietMany(remaining),
            ),
          const SizedBox(height: 12),
          for (final d in _days)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prettyDate(d).toUpperCase(),
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      if (pending(d))
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          OutlinedButton(
                            key: Key('quiet-$d'),
                            onPressed: () => repo.markQuiet(d),
                            child: const Text('Nothing notable'),
                          ),
                          OutlinedButton(
                            key: Key('add-$d'),
                            onPressed: () => context.push('/day/$d'),
                            child: const Text('Add something'),
                          ),
                          OutlinedButton(
                            key: Key('skip-$d'),
                            onPressed: () => repo.addSkippedCatchup(d),
                            child: const Text("I don't remember"),
                          ),
                        ])
                      else
                        Row(children: [
                          Icon(
                            switch (summaries[d]?.status) {
                              DayStatus.confirmedQuiet => Icons.check,
                              DayStatus.hasNotableEntries => Icons.edit_note,
                              _ => Icons.remove,
                            },
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(switch (summaries[d]?.status) {
                            DayStatus.confirmedQuiet => 'Nothing notable',
                            DayStatus.hasNotableEntries => 'Recorded',
                            _ => 'Left blank',
                          }),
                        ]),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Shown on the calendar when recent days are unrecorded.
class CatchUpBanner extends ConsumerWidget {
  const CatchUpBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missed = ref.watch(missedDaysProvider);
    if (missed.isEmpty) return const SizedBox.shrink();
    final n = missed.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                n == 1
                    ? "You haven't checked in for 1 day. Anything notable happen?"
                    : "You haven't checked in for $n days. Anything notable happen during those days?",
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                key: const Key('catchUpBanner'),
                onPressed: () => context.push('/catchup'),
                child: const Text('Catch up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
