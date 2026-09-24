import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/vocab.dart';
import '../providers.dart';
import '../widgets/chip_select.dart';
import '../widgets/common_fields.dart';

/// "Anything unusual with your libido?" — an exception event, never a daily rating.
class LibidoFormScreen extends ConsumerStatefulWidget {
  const LibidoFormScreen({super.key, required this.date, this.editId});
  final String date;
  final String? editId;

  @override
  ConsumerState<LibidoFormScreen> createState() => _LibidoFormState();
}

class _LibidoFormState extends ConsumerState<LibidoFormScreen> {
  late final CommonFields _common = CommonFields(widget.date);
  String? _direction;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.editId;
    if (id != null) {
      final row = await ref.read(repositoryProvider).getLibido(id);
      if (row != null) {
        _direction = row.direction;
        _common.load(time: row.localTime, source: row.source, notes: row.notes);
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _common.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(repositoryProvider).saveLibido(
          id: widget.editId,
          localDate: widget.date,
          localTime: _common.time,
          source: _common.source,
          direction: _direction!,
          notes: _common.notes.text,
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) => EventFormFrame(
        title: widget.editId == null ? 'Unusual libido' : 'Edit libido entry',
        date: widget.date,
        loading: _loading,
        canSave: _direction != null,
        onSave: _save,
        children: [
          const SectionLabel('Anything unusual with your libido?'),
          SingleChipSelect(
            group: 'libido',
            options: libidoDirections,
            selected: _direction,
            onChanged: (v) => setState(() => _direction = v),
          ),
          const SizedBox(height: 12),
          MoreDetails(children: _common.detailWidgets(setState)),
          const SectionLabel('Notes'),
          _common.notesField(),
        ],
      );
}

/// "Did you experience any unusually strong emotional state?" — broad categories only.
class MoodFormScreen extends ConsumerStatefulWidget {
  const MoodFormScreen({super.key, required this.date, this.editId});
  final String date;
  final String? editId;

  @override
  ConsumerState<MoodFormScreen> createState() => _MoodFormState();
}

class _MoodFormState extends ConsumerState<MoodFormScreen> {
  late final CommonFields _common = CommonFields(widget.date);
  List<String> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.editId;
    if (id != null) {
      final row = await ref.read(repositoryProvider).getMood(id);
      if (row != null) {
        _categories = [...row.categories];
        _common.load(time: row.localTime, source: row.source, notes: row.notes);
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _common.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(repositoryProvider).saveMood(
          id: widget.editId,
          localDate: widget.date,
          localTime: _common.time,
          source: _common.source,
          categories: _categories,
          notes: _common.notes.text,
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) => EventFormFrame(
        title: widget.editId == null ? 'Unusual mood / emotion' : 'Edit mood entry',
        date: widget.date,
        loading: _loading,
        canSave: _categories.isNotEmpty,
        onSave: _save,
        children: [
          const SectionLabel('Any unusually strong emotional state?'),
          MultiChipSelect(
            group: 'mood',
            options: moodCategories,
            selected: _categories,
            onChanged: (v) => setState(() => _categories = v),
          ),
          const SizedBox(height: 12),
          MoreDetails(children: _common.detailWidgets(setState)),
          const SectionLabel('Notes'),
          _common.notesField(),
        ],
      );
}

/// Physical symptoms; pain details only appear for pain-type symptoms.
class SymptomFormScreen extends ConsumerStatefulWidget {
  const SymptomFormScreen({super.key, required this.date, this.editId});
  final String date;
  final String? editId;

  @override
  ConsumerState<SymptomFormScreen> createState() => _SymptomFormState();
}

class _SymptomFormState extends ConsumerState<SymptomFormScreen> {
  late final CommonFields _common = CommonFields(widget.date);
  String? _type;
  int? _severity;
  List<String> _locations = [];
  List<String> _qualities = [];
  bool _loading = true;

  static final _severityOptions = [
    for (var i = 0; i <= 10; i++) Option('$i', '$i'),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.editId;
    if (id != null) {
      final row = await ref.read(repositoryProvider).getSymptom(id);
      if (row != null) {
        _type = row.symptomType;
        _severity = row.severity;
        _locations = [...row.locations];
        _qualities = [...row.qualities];
        _common.load(time: row.localTime, source: row.source, notes: row.notes);
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _common.dispose();
    super.dispose();
  }

  bool get _isPain => _type != null && painSymptomKeys.contains(_type);

  Future<void> _save() async {
    await ref.read(repositoryProvider).saveSymptom(
          id: widget.editId,
          localDate: widget.date,
          localTime: _common.time,
          source: _common.source,
          symptomType: _type!,
          severity: _isPain ? _severity : null,
          locations: _isPain ? _locations : const [],
          qualities: _isPain ? _qualities : const [],
          notes: _common.notes.text,
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) => EventFormFrame(
        title: widget.editId == null ? 'Physical symptom' : 'Edit symptom',
        date: widget.date,
        loading: _loading,
        canSave: _type != null,
        onSave: _save,
        children: [
          const SectionLabel('What did you notice?'),
          SingleChipSelect(
            group: 'symptom',
            options: physicalSymptomTypes,
            selected: _type,
            onChanged: (v) => setState(() => _type = v),
          ),
          if (_isPain) ...[
            const SectionLabel('Pain severity, 0–10 (optional)'),
            SingleChipSelect(
              group: 'severity',
              options: _severityOptions,
              selected: _severity?.toString(),
              onChanged: (v) => setState(() => _severity = v == null ? null : int.parse(v)),
            ),
            const SectionLabel('Where? (optional)'),
            MultiChipSelect(
              group: 'painLocation',
              options: painLocations,
              selected: _locations,
              onChanged: (v) => setState(() => _locations = v),
            ),
            const SectionLabel('What did it feel like? (optional)'),
            MultiChipSelect(
              group: 'painQuality',
              options: painQualities,
              selected: _qualities,
              onChanged: (v) => setState(() => _qualities = v),
            ),
          ],
          const SizedBox(height: 12),
          MoreDetails(children: _common.detailWidgets(setState)),
          const SectionLabel('Notes'),
          _common.notesField(),
        ],
      );
}
