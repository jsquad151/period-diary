import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/date_utils.dart';
import '../data/day_status.dart';
import '../providers.dart';
import '../widgets/entry_list.dart';

class DayScreen extends ConsumerWidget {
  const DayScreen({super.key, required this.date});
  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(daySummariesProvider)[date] ?? DaySummary(date);
    final status = summary.status;
    final repo = ref.read(repositoryProvider);
    final theme = Theme.of(context);
    final isFuture = date.compareTo(formatLocalDate(DateTime.now())) > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(prettyDate(date)),
        actions: [
          IconButton(
            tooltip: 'Previous day',
            icon: const Icon(Icons.chevron_left),
            onPressed: () =>
                context.pushReplacement('/day/${addDaysToLocalDate(date, -1)}'),
          ),
          IconButton(
            tooltip: 'Next day',
            icon: const Icon(Icons.chevron_right),
            onPressed: isFuture
                ? null
                : () => context.pushReplacement('/day/${addDaysToLocalDate(date, 1)}'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _StatusCard(status: status, summary: summary),
            const SizedBox(height: 12),
            if (status != DayStatus.hasNotableEntries)
              status == DayStatus.confirmedQuiet
                  ? OutlinedButton.icon(
                      key: const Key('undoQuiet'),
                      icon: const Icon(Icons.undo),
                      label: const Text('Remove "Nothing notable" mark'),
                      onPressed: () => repo.clearQuiet(date),
                    )
                  : FilledButton.icon(
                      key: const Key('nothingNotable'),
                      icon: const Icon(Icons.check),
                      label: const Text('Nothing notable today'),
                      onPressed: () => repo.markQuiet(date),
                    ),
            const SizedBox(height: 20),
            Text('Add an observation', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              key: const Key('addFluid'),
              icon: const Icon(Icons.water_drop),
              label: const Text('Bleeding / discharge'),
              onPressed: () => context.push('/day/$date/fluid'),
            ),
            EntryList(date: date),
            const SizedBox(height: 20),
            _DailyNoteField(date: date),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status, required this.summary});
  final DayStatus status;
  final DaySummary summary;

  @override
  Widget build(BuildContext context) {
    final (icon, text) = switch (status) {
      DayStatus.unobserved => (Icons.radio_button_unchecked, 'Not checked'),
      DayStatus.confirmedQuiet => (Icons.check_circle_outline, 'Nothing notable recorded'),
      DayStatus.hasNotableEntries => (
          Icons.circle,
          summary.entryCount == 1
              ? '1 notable observation'
              : '${summary.entryCount} notable observations'
        ),
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  key: const Key('statusText'),
                  style: Theme.of(context).textTheme.titleMedium)),
        ]),
      ),
    );
  }
}

class _DailyNoteField extends ConsumerStatefulWidget {
  const _DailyNoteField({required this.date});
  final String date;

  @override
  ConsumerState<_DailyNoteField> createState() => _DailyNoteFieldState();
}

class _DailyNoteFieldState extends ConsumerState<_DailyNoteField> {
  final _controller = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final row = await (db.select(db.dailyNotes)
          ..where((t) => t.localDate.equals(widget.date)))
        .getSingleOrNull();
    if (!mounted) return;
    setState(() {
      _controller.text = row?.text_ ?? '';
      _loaded = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('dailyNote'),
      controller: _controller,
      enabled: _loaded,
      minLines: 2,
      maxLines: 6,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Notes for the day (optional)',
        border: OutlineInputBorder(),
      ),
      onChanged: (v) => ref.read(repositoryProvider).saveDailyNote(widget.date, v),
    );
  }
}
