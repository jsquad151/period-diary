import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/converters.dart';
import '../data/date_utils.dart';
import '../data/vocab.dart';
import '../providers.dart';
import '../widgets/chip_select.dart';
import '../widgets/time_field.dart';

/// "What did you notice?" — records raw observations only. Nothing here asks
/// whether this is a period; blood presence "I don't know" is a valid answer.
class FluidFormScreen extends ConsumerStatefulWidget {
  const FluidFormScreen({super.key, required this.date, this.editId});
  final String date;
  final String? editId;

  @override
  ConsumerState<FluidFormScreen> createState() => _FluidFormScreenState();
}

class _FluidFormScreenState extends ConsumerState<FluidFormScreen> {
  bool _loading = true;

  List<String> _material = [];
  List<String> _colours = [];
  String? _amount;
  List<String> _textures = [];
  String _blood = 'unknown';
  List<String> _visibility = [];
  String? _odour;
  bool _hasClot = false;
  String _clotPresence = 'possible';
  String? _clotQuantity;
  String? _clotSize;
  final _clotMm = TextEditingController();
  List<String> _clotAppearance = [];
  final _notes = TextEditingController();
  String? _time;
  late String _source;

  bool get _isToday => widget.date == formatLocalDate(DateTime.now());

  @override
  void initState() {
    super.initState();
    _source = _isToday ? sourceRealtime : sourceReconstructed;
    _time = _isToday ? formatLocalTime(DateTime.now()) : null;
    _load();
  }

  Future<void> _load() async {
    final id = widget.editId;
    if (id != null) {
      final row = await ref.read(repositoryProvider).getFluid(id);
      if (row != null && mounted) {
        _material = [...row.materialTypes];
        _colours = [...row.colours];
        _amount = row.amount;
        _textures = [...row.textures];
        _blood = row.bloodPresence;
        _visibility = [...row.visibilityContexts];
        _odour = row.odourChange;
        final clot = row.clot;
        if (clot != null) {
          _hasClot = true;
          _clotPresence = clot.presence;
          _clotQuantity = clot.quantity;
          _clotSize = clot.sizeCategory;
          _clotMm.text = clot.largestApproximateSizeMm?.toString() ?? '';
          _clotAppearance = [...clot.appearance];
        }
        _notes.text = row.notes ?? '';
        _time = row.localTime;
        _source = row.source;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _clotMm.dispose();
    _notes.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _material.isNotEmpty ||
      _colours.isNotEmpty ||
      _textures.isNotEmpty ||
      _amount != null ||
      _hasClot;

  Future<void> _save() async {
    final mm = int.tryParse(_clotMm.text.trim());
    await ref.read(repositoryProvider).saveFluid(
          id: widget.editId,
          localDate: widget.date,
          localTime: _time,
          source: _source,
          materialTypes: _material,
          colours: _colours,
          amount: _amount,
          textures: _textures,
          bloodPresence: _blood,
          visibilityContexts: _visibility,
          odourChange: _odour,
          clot: _hasClot
              ? ClotObservation(
                  presence: _clotPresence,
                  quantity: _clotQuantity,
                  largestApproximateSizeMm: mm,
                  sizeCategory: _clotSize,
                  appearance: _clotAppearance,
                )
              : null,
          notes: _notes.text,
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.editId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Edit observation' : 'Bleeding / discharge'),
      ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(prettyDate(widget.date),
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                const SectionLabel('What did you notice?'),
                MultiChipSelect(
                  group: 'material', options: materialTypes,
                  selected: _material,
                  onChanged: (v) => setState(() {
                    _material = v;
                    if (v.contains('clot')) _hasClot = true;
                  }),
                ),
                const SectionLabel('Colour'),
                MultiChipSelect(
                  group: 'colour', options: fluidColours,
                  selected: _colours,
                  onChanged: (v) => setState(() => _colours = v),
                ),
                const SectionLabel('Approximately how much material / fluid?'),
                SingleChipSelect(
                  group: 'amount', options: fluidAmounts,
                  selected: _amount,
                  onChanged: (v) => setState(() => _amount = v),
                ),
                const SectionLabel('Texture'),
                MultiChipSelect(
                  group: 'texture', options: fluidTextures,
                  selected: _textures,
                  onChanged: (v) => setState(() => _textures = v),
                ),
                const SectionLabel('Was there blood?'),
                SingleChipSelect(
                  group: 'blood', options: bloodPresenceOptions,
                  selected: _blood,
                  required: true,
                  onChanged: (v) => setState(() => _blood = v ?? 'unknown'),
                ),
                const SizedBox(height: 12),
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    key: const Key('moreDetails'),
                    tilePadding: EdgeInsets.zero,
                    title: const Text('More details (optional)'),
                    childrenPadding: EdgeInsets.zero,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionLabel('Time'),
                      TimeField(value: _time, onChanged: (v) => setState(() => _time = v)),
                      const SectionLabel('How was it noticed?'),
                      MultiChipSelect(
                        group: 'visibility', options: visibilityContexts,
                        selected: _visibility,
                        onChanged: (v) => setState(() => _visibility = v),
                      ),
                      const SectionLabel('Odour'),
                      SingleChipSelect(
                        group: 'odour', options: odourOptions,
                        selected: _odour,
                        onChanged: (v) => setState(() => _odour = v),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        key: const Key('clotSwitch'),
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Clot noticed'),
                        value: _hasClot,
                        onChanged: (v) => setState(() => _hasClot = v),
                      ),
                      if (_hasClot) ..._clotSection(),
                      const SectionLabel('This entry was'),
                      SingleChipSelect(
                        group: 'source',
                        options: const [
                          Option(sourceRealtime, 'Recorded at the time'),
                          Option(sourceReconstructed, 'Remembered afterwards'),
                        ],
                        selected: _source,
                        required: true,
                        onChanged: (v) => setState(() => _source = v ?? _source),
                      ),
                    ],
                  ),
                ),
                const SectionLabel('Notes'),
                TextField(
                  key: const Key('notes'),
                  controller: _notes,
                  minLines: 2,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Anything else (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _clotSection() => [
        const SectionLabel('Clot: how sure?'),
        SingleChipSelect(
          group: 'clotPresence', options: clotPresenceOptions,
          selected: _clotPresence,
          required: true,
          onChanged: (v) => setState(() => _clotPresence = v ?? 'possible'),
        ),
        const SectionLabel('How many?'),
        SingleChipSelect(
          group: 'clotQty', options: clotQuantities,
          selected: _clotQuantity,
          onChanged: (v) => setState(() => _clotQuantity = v),
        ),
        const SectionLabel('Largest size (approx.)'),
        SingleChipSelect(
          group: 'clotSize', options: clotSizes,
          selected: _clotSize,
          onChanged: (v) => setState(() => _clotSize = v),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('clotMm'),
          controller: _clotMm,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Size in mm (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        const SectionLabel('What did it look like?'),
        MultiChipSelect(
          group: 'clotLook', options: clotAppearances,
          selected: _clotAppearance,
          onChanged: (v) => setState(() => _clotAppearance = v),
        ),
      ];
}
