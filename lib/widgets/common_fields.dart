import 'package:flutter/material.dart';

import '../data/date_utils.dart';
import '../data/vocab.dart';
import 'chip_select.dart';
import 'time_field.dart';

/// Time / source / notes shared by every event form.
class CommonFields {
  CommonFields(this.date) {
    final today = formatLocalDate(DateTime.now());
    source = date == today ? sourceRealtime : sourceReconstructed;
    time = date == today ? formatLocalTime(DateTime.now()) : null;
  }

  final String date;
  final TextEditingController notes = TextEditingController();
  String? time;
  late String source;

  /// Overwrites defaults with the values of a row being edited.
  void load({String? time, required String source, String? notes}) {
    this.time = time;
    this.source = source;
    this.notes.text = notes ?? '';
  }

  void dispose() => notes.dispose();

  /// Optional time + provenance, meant to sit under a "More details" tile.
  List<Widget> detailWidgets(void Function(VoidCallback) setState) => [
        const SectionLabel('Time'),
        TimeField(value: time, onChanged: (v) => setState(() => time = v)),
        const SectionLabel('This entry was'),
        SingleChipSelect(
          group: 'source',
          options: const [
            Option(sourceRealtime, 'Recorded at the time'),
            Option(sourceReconstructed, 'Remembered afterwards'),
          ],
          selected: source,
          required: true,
          onChanged: (v) => setState(() => source = v ?? source),
        ),
      ];

  Widget notesField() => TextField(
        key: const Key('notes'),
        controller: notes,
        minLines: 2,
        maxLines: 5,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          hintText: 'Anything else (optional)',
          border: OutlineInputBorder(),
        ),
      );
}

/// Standard frame: app bar, scrolling body, sticky Save button.
class EventFormFrame extends StatelessWidget {
  const EventFormFrame({
    super.key,
    required this.title,
    required this.date,
    required this.loading,
    required this.canSave,
    required this.onSave,
    required this.children,
  });

  final String title;
  final String date;
  final bool loading;
  final bool canSave;
  final VoidCallback onSave;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton(
            key: const Key('save'),
            onPressed: canSave && !loading ? onSave : null,
            child: const Text('Save'),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(prettyDate(date),
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                ...children,
              ],
            ),
    );
  }
}

/// Collapsed-by-default section for optional details.
class MoreDetails extends StatelessWidget {
  const MoreDetails({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: const Key('moreDetails'),
          tilePadding: EdgeInsets.zero,
          title: const Text('More details (optional)'),
          childrenPadding: EdgeInsets.zero,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
}
