import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/date_utils.dart';
import '../data/vocab.dart';
import '../providers.dart';
import '../widgets/chip_select.dart';

/// Health context events (contraception, medication, illness...) with dates
/// that may be approximate. They help later interpretation; they never imply cause.
class ContextListScreen extends ConsumerWidget {
  const ContextListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = [...(ref.watch(contextEventsProvider).value ?? const [])]
      ..sort((a, b) => b.dateStart.compareTo(a.dateStart));
    return Scaffold(
      appBar: AppBar(title: const Text('Health context')),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('addContext'),
        onPressed: () => context.push('/context/edit'),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: events.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Things like starting or stopping contraception, medication '
                  'changes or illness. Dates can be approximate.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                for (final e in events)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: ListTile(
                        key: Key('context-${e.id}'),
                        title: Text(e.title),
                        subtitle: Text(
                            '${labelFor(contextEventTypes, e.type)}\n'
                            '${describeDateEstimate(e.datePrecision, e.dateStart, e.dateEnd)}'
                            '${e.notes == null ? '' : '\n${e.notes}'}'),
                        isThreeLine: true,
                        onTap: () => context.push('/context/edit?id=${e.id}'),
                        trailing: PopupMenuButton<String>(
                          tooltip: 'Options',
                          onSelected: (v) async {
                            if (v == 'edit') {
                              context.push('/context/edit?id=${e.id}');
                              return;
                            }
                            final messenger = ScaffoldMessenger.of(context);
                            final repo = ref.read(repositoryProvider);
                            final ok = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete this event?'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      key: const Key('confirmDelete'),
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Delete')),
                                ],
                              ),
                            );
                            if (ok != true) return;
                            final removed = await repo.deleteContext(e.id);
                            messenger
                              ..clearSnackBars()
                              ..showSnackBar(SnackBar(
                                content: const Text('Event deleted'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    if (removed != null) repo.restoreContext(removed);
                                  },
                                ),
                              ));
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(value: 'delete', child: Text('Delete')),
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

class ContextFormScreen extends ConsumerStatefulWidget {
  const ContextFormScreen({super.key, this.editId});
  final String? editId;

  @override
  ConsumerState<ContextFormScreen> createState() => _ContextFormState();
}

class _ContextFormState extends ConsumerState<ContextFormScreen> {
  String? _type;
  String _precision = 'exact';
  String _start = formatLocalDate(DateTime.now());
  String? _end;
  final _title = TextEditingController();
  final _notes = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.editId;
    if (id != null) {
      final db = ref.read(databaseProvider);
      final row = await (db.select(db.contextEvents)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (row != null) {
        _type = row.type;
        _precision = row.datePrecision;
        _start = row.dateStart;
        _end = row.dateEnd;
        _title.text = row.title;
        _notes.text = row.notes ?? '';
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<String?> _pickDate(String initial) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: parseLocalDate(initial),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    return picked == null ? null : formatLocalDate(picked);
  }

  bool get _canSave => _type != null && _title.text.trim().isNotEmpty;

  Future<void> _save() async {
    await ref.read(repositoryProvider).saveContext(
          id: widget.editId,
          datePrecision: _precision,
          dateStart: _start,
          dateEnd: _end ?? _start,
          type: _type!,
          title: _title.text,
          notes: _notes.text,
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.editId == null ? 'Add health event' : 'Edit health event')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton(
            key: const Key('save'),
            onPressed: _canSave && !_loading ? _save : null,
            child: const Text('Save'),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                const SectionLabel('What kind of event?'),
                SingleChipSelect(
                  group: 'ctxType',
                  options: contextEventTypes,
                  selected: _type,
                  onChanged: (v) => setState(() {
                    _type = v;
                    if (v != null && _title.text.trim().isEmpty) {
                      _title.text = labelFor(contextEventTypes, v);
                    }
                  }),
                ),
                const SectionLabel('Title'),
                TextField(
                  key: const Key('ctxTitle'),
                  controller: _title,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
                const SectionLabel('How sure are you of the date?'),
                SingleChipSelect(
                  group: 'ctxPrecision',
                  options: datePrecisions,
                  selected: _precision,
                  required: true,
                  onChanged: (v) => setState(() => _precision = v ?? 'exact'),
                ),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  OutlinedButton.icon(
                    key: const Key('pickStart'),
                    icon: const Icon(Icons.event),
                    label: Text(_precision == 'range'
                        ? 'From ${shortDate(_start)}'
                        : describeDateEstimate(_precision, _start, _end)),
                    onPressed: () async {
                      final d = await _pickDate(_start);
                      if (d != null) setState(() => _start = d);
                    },
                  ),
                  if (_precision == 'range')
                    OutlinedButton.icon(
                      key: const Key('pickEnd'),
                      icon: const Icon(Icons.event),
                      label: Text('To ${shortDate(_end ?? _start)}'),
                      onPressed: () async {
                        final d = await _pickDate(_end ?? _start);
                        if (d != null) setState(() => _end = d);
                      },
                    ),
                ]),
                if (_precision == 'month_only')
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text('Pick any day in the month.'),
                  ),
                const SectionLabel('Notes'),
                TextField(
                  key: const Key('notes'),
                  controller: _notes,
                  minLines: 2,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      hintText: 'Optional', border: OutlineInputBorder()),
                ),
              ],
            ),
    );
  }
}
