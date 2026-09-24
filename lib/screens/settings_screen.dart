import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/backup.dart';
import '../data/date_utils.dart';
import '../data/file_gateway.dart';
import '../data/reminders.dart';
import '../data/repository.dart';
import '../providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final last = ref.watch(lastExportProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            key: const Key('openContext'),
            leading: const Icon(Icons.medical_information_outlined),
            title: const Text('Health context'),
            subtitle: const Text('Contraception, medication, illness and other events'),
            onTap: () => context.push('/context'),
          ),
          const _SectionHeader('Reminder'),
          const _ReminderTiles(),
          const _SectionHeader('Your data'),
          const ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Stored only on this phone'),
            subtitle: Text(
                'No account, no cloud, nothing is sent anywhere. Because of that, '
                'export a backup now and then: if the phone is lost or wiped, '
                'the data goes with it.'),
          ),
          ListTile(
            key: const Key('exportJson'),
            leading: const Icon(Icons.save_alt),
            title: const Text('Export backup (JSON)'),
            subtitle: Text(last == null
                ? 'Not exported yet'
                : 'Last exported ${describeStamp(last)}'),
            onTap: () => _exportJson(context, ref),
          ),
          ListTile(
            key: const Key('exportCsv'),
            leading: const Icon(Icons.table_chart_outlined),
            title: const Text('Export as spreadsheets (CSV)'),
            subtitle: const Text('One readable file per type of record'),
            onTap: () => _exportCsv(context, ref),
          ),
          ListTile(
            key: const Key('importJson'),
            leading: const Icon(Icons.restore),
            title: const Text('Import from backup'),
            subtitle: const Text('Restore a JSON backup made by this app'),
            onTap: () => _import(context, ref),
          ),
          ListTile(
            key: const Key('deleteAll'),
            leading: Icon(Icons.delete_forever_outlined,
                color: Theme.of(context).colorScheme.error),
            title: Text('Delete all data',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onTap: () => _deleteAll(context, ref),
          ),
        ],
      ),
    );
  }
}

/// `2026-09-24T20:00:00+02:00` -> `24 Sep 2026`.
String describeStamp(String stamp) =>
    stamp.length >= 10 ? describeDateEstimate('exact', stamp.substring(0, 10), null) : stamp;

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
        child: Text(text.toUpperCase(), style: Theme.of(context).textTheme.labelLarge),
      );
}

void _toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Runs the JSON export; returns true if the file was saved.
Future<bool> _exportJson(BuildContext context, WidgetRef ref) async {
  final db = ref.read(databaseProvider);
  final gateway = ref.read(fileGatewayProvider);
  final repo = ref.read(repositoryProvider);
  final backup = await exportBackup(db);
  final name = 'cycle-tracker-backup-${formatLocalDate(DateTime.now())}.json';
  bool saved;
  try {
    saved = await gateway.saveFile(
        GatewayFile.text(name, encodeBackup(backup), 'application/json'));
  } catch (e) {
    if (context.mounted) _toast(context, 'Could not save the backup: $e');
    return false;
  }
  if (saved) {
    await repo.setSetting(Repository.lastExportKey, backup['exportedAt']! as String);
    if (context.mounted) _toast(context, 'Backup saved');
  }
  return saved;
}

Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
  final files = await buildCsvFiles(ref.read(databaseProvider));
  try {
    await ref.read(fileGatewayProvider).shareFiles([
      for (final e in files.entries) GatewayFile.text(e.key, e.value, 'text/csv'),
    ]);
  } catch (e) {
    if (context.mounted) _toast(context, 'Could not share the files: $e');
  }
}

Future<void> _import(BuildContext context, WidgetRef ref) async {
  final db = ref.read(databaseProvider);
  final String? text;
  try {
    text = await ref.read(fileGatewayProvider).pickText();
  } catch (e) {
    if (context.mounted) _toast(context, 'Could not read that file: $e');
    return;
  }
  if (text == null) return;

  final Map<String, dynamic> root;
  final ImportPreview preview;
  try {
    root = decodeBackup(text);
    preview = await previewBackup(db, root);
  } on BackupException catch (e) {
    if (context.mounted) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          key: const Key('importError'),
          title: const Text('Can\'t import this file'),
          content: Text(e.message),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
    }
    return;
  }
  if (!context.mounted) return;

  final mode = await showDialog<ImportMode>(
    context: context,
    builder: (ctx) => _ImportDialog(preview: preview),
  );
  if (mode == null) return;
  try {
    await applyBackup(db, root, mode);
    if (context.mounted) {
      _toast(
          context,
          mode == ImportMode.merge
              ? 'Imported ${preview.addedRows} new records'
              : 'Restored ${preview.totalRows} records');
    }
  } on BackupException catch (e) {
    if (context.mounted) _toast(context, e.message);
  }
}

class _ImportDialog extends StatefulWidget {
  const _ImportDialog({required this.preview});
  final ImportPreview preview;

  @override
  State<_ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<_ImportDialog> {
  ImportMode _mode = ImportMode.merge;

  @override
  Widget build(BuildContext context) {
    final p = widget.preview;
    final replace = _mode == ImportMode.replace;
    return AlertDialog(
      key: const Key('importDialog'),
      title: const Text('Import backup'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (p.exportedAt != null) Text('Made ${describeStamp(p.exportedAt!)}.'),
            const SizedBox(height: 8),
            Text('${p.totalRows} records in the file: ${p.addedRows} new, '
                '${p.existingRows} already on this phone.',
                key: const Key('importSummary')),
            const SizedBox(height: 12),
            RadioGroup<ImportMode>(
              groupValue: _mode,
              onChanged: (v) => setState(() => _mode = v ?? _mode),
              child: const Column(children: [
                RadioListTile<ImportMode>(
                  key: Key('modeMerge'),
                  contentPadding: EdgeInsets.zero,
                  value: ImportMode.merge,
                  title: Text('Add what\'s missing'),
                  subtitle: Text('Keeps everything already here. Records that already exist are left untouched.'),
                ),
                RadioListTile<ImportMode>(
                  key: Key('modeReplace'),
                  contentPadding: EdgeInsets.zero,
                  value: ImportMode.replace,
                  title: Text('Replace everything'),
                  subtitle: Text('Erases what is on this phone first, then loads the file.'),
                ),
              ]),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          key: const Key('confirmImport'),
          onPressed: () => Navigator.pop(context, _mode),
          style: replace
              ? FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error)
              : null,
          child: Text(replace ? 'Replace all data' : 'Import'),
        ),
      ],
    );
  }
}

Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => _DeleteAllDialog(
      onExport: () => _exportJson(ctx, ref),
    ),
  );
  if (confirmed != true) return;
  await ref.read(repositoryProvider).deleteAllData();
  if (context.mounted) _toast(context, 'All data deleted');
}

class _DeleteAllDialog extends StatefulWidget {
  const _DeleteAllDialog({required this.onExport});
  final Future<bool> Function() onExport;

  @override
  State<_DeleteAllDialog> createState() => _DeleteAllDialogState();
}

class _DeleteAllDialogState extends State<_DeleteAllDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ok = _controller.text.trim().toLowerCase() == 'delete';
    return AlertDialog(
      key: const Key('deleteDialog'),
      title: const Text('Delete all data?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This permanently erases every record on this phone. '
              'It can\'t be undone. Export a backup first if you might want it back.'),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            key: const Key('exportFirst'),
            icon: const Icon(Icons.save_alt),
            label: const Text('Export a backup first'),
            onPressed: widget.onExport,
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('deleteConfirmField'),
            controller: _controller,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Type "delete" to confirm',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(
          key: const Key('confirmDeleteAll'),
          style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
          onPressed: ok ? () => Navigator.pop(context, true) : null,
          child: const Text('Delete everything'),
        ),
      ],
    );
  }
}

/// Optional daily "Anything notable today?" nudge. Off by default, no streaks.
class _ReminderTiles extends ConsumerWidget {
  const _ReminderTiles();

  Future<void> _toggle(BuildContext context, WidgetRef ref, bool on) async {
    final repo = ref.read(repositoryProvider);
    final scheduler = ref.read(reminderSchedulerProvider);
    final setting = ref.read(reminderSettingProvider);
    if (!on) {
      await scheduler.disable();
      await repo.setSetting(reminderEnabledKey, '0');
      return;
    }
    final t = parseReminderTime(setting.time)!;
    final ok = await scheduler.enable(t.$1, t.$2);
    if (!ok) {
      if (context.mounted) {
        _toast(context, 'Notifications are turned off for this app in Android settings.');
      }
      return;
    }
    await repo.setSetting(reminderEnabledKey, '1');
    await repo.setSetting(reminderTimeKey, setting.time);
  }

  Future<void> _pickTime(BuildContext context, WidgetRef ref) async {
    final setting = ref.read(reminderSettingProvider);
    final t = parseReminderTime(setting.time)!;
    final picked = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour: t.$1, minute: t.$2));
    if (picked == null) return;
    final value = formatReminderTime(picked.hour, picked.minute);
    final repo = ref.read(repositoryProvider);
    await repo.setSetting(reminderTimeKey, value);
    if (setting.enabled) {
      await ref.read(reminderSchedulerProvider).enable(picked.hour, picked.minute);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(reminderSettingProvider);
    return Column(children: [
      SwitchListTile(
        key: const Key('reminderSwitch'),
        secondary: const Icon(Icons.notifications_none),
        title: const Text('Daily check-in reminder'),
        subtitle: const Text('A quiet nudge that just says "Anything notable today?"'),
        value: s.enabled,
        onChanged: (v) => _toggle(context, ref, v),
      ),
      ListTile(
        key: const Key('reminderTime'),
        enabled: s.enabled,
        leading: const Icon(Icons.schedule),
        title: const Text('Reminder time'),
        trailing: Text(s.time),
        onTap: s.enabled ? () => _pickTime(context, ref) : null,
      ),
    ]);
  }
}
