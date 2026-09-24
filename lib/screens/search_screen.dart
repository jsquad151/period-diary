import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/date_utils.dart';
import '../data/entries.dart';
import '../data/filter.dart';
import '../data/vocab.dart';
import '../providers.dart';
import '../widgets/chip_select.dart';
import '../widgets/entry_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  EntryFilter _filter = const EntryFilter();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _activeCount {
    final f = _filter;
    return [
      f.from != null || f.to != null,
      f.kinds.isNotEmpty,
      f.source != null,
      f.quietOnly,
      f.colours.isNotEmpty,
      f.amounts.isNotEmpty,
      f.textures.isNotEmpty,
      f.bloodPresence.isNotEmpty,
      f.clotPresent,
      f.clotSizes.isNotEmpty,
      f.libidoDirections.isNotEmpty,
      f.moodCategories.isNotEmpty,
      f.symptomTypes.isNotEmpty,
    ].where((b) => b).length;
  }

  @override
  Widget build(BuildContext context) {
    final results = applyFilter(
      _filter,
      fluids: ref.watch(fluidsProvider).value ?? const [],
      libidos: ref.watch(libidosProvider).value ?? const [],
      moods: ref.watch(moodsProvider).value ?? const [],
      symptoms: ref.watch(symptomsProvider).value ?? const [],
      checkIns: ref.watch(checkInsProvider).value ?? const [],
      notes: ref.watch(dailyNotesProvider).value ?? const [],
    );
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(children: [
              Expanded(
                child: TextField(
                  key: const Key('searchField'),
                  controller: _controller,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search notes',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _filter = _filter.copyWith(query: v)),
                ),
              ),
              const SizedBox(width: 8),
              Badge(
                isLabelVisible: _activeCount > 0,
                label: Text('$_activeCount'),
                child: IconButton.filledTonal(
                  key: const Key('openFilters'),
                  tooltip: 'Filters',
                  icon: const Icon(Icons.tune),
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (_) => FilterSheet(
                      initial: _filter,
                      onChanged: (f) => setState(() => _filter = f),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Expanded(
            child: _filter.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Search your notes, or use the filter button to find, for '
                        'example, every day with watery brown material.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  )
                : results.total == 0
                    ? const Center(child: Text('No matches', key: Key('noMatches')))
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text('${results.total} '
                                '${results.total == 1 ? 'result' : 'results'}',
                                key: const Key('resultCount')),
                          ),
                          for (final d in results.quietDays)
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.check),
                                title: Text(prettyDate(d)),
                                subtitle: const Text('Nothing notable'),
                                onTap: () => context.push('/day/$d'),
                              ),
                            ),
                          for (final n in results.noteHits)
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.notes),
                                title: Text(prettyDate(n.date)),
                                subtitle: Text(n.text),
                                onTap: () => context.push('/day/${n.date}'),
                              ),
                            ),
                          for (final e in results.entries)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: EntryTile(entry: e, showDate: true),
                            ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key, required this.initial, required this.onChanged});
  final EntryFilter initial;
  final ValueChanged<EntryFilter> onChanged;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late EntryFilter _f = widget.initial;

  void _set(EntryFilter f) {
    setState(() => _f = f);
    widget.onChanged(f);
  }

  Future<void> _pick(bool isFrom) async {
    final current = isFrom ? _f.from : _f.to;
    final d = await showDatePicker(
      context: context,
      initialDate: current == null ? DateTime.now() : parseLocalDate(current),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (d == null) return;
    final s = formatLocalDate(d);
    _set(isFrom ? _f.copyWith(from: s) : _f.copyWith(to: s));
  }

  @override
  Widget build(BuildContext context) {
    final f = _f;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          Row(children: [
            Expanded(
                child: Text('Filters', style: Theme.of(context).textTheme.titleLarge)),
            TextButton(
              key: const Key('clearFilters'),
              onPressed: () => _set(EntryFilter(query: f.query)),
              child: const Text('Clear all'),
            ),
            FilledButton(
              key: const Key('closeFilters'),
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ]),
          const SectionLabel('Show'),
          MultiChipSelect(
            group: 'fkind',
            options: const [
              Option('fluid', 'Bleeding / discharge'),
              Option('symptom', 'Physical symptoms'),
              Option('libido', 'Libido'),
              Option('mood', 'Mood'),
            ],
            selected: [for (final k in f.kinds) k.name],
            onChanged: (v) => _set(f.copyWith(
                kinds: {for (final k in EntryKind.values) if (v.contains(k.name)) k})),
          ),
          const SectionLabel('Dates'),
          Wrap(spacing: 8, children: [
            OutlinedButton(
                key: const Key('filterFrom'),
                onPressed: () => _pick(true),
                child: Text(f.from == null ? 'From' : 'From ${shortDate(f.from!)}')),
            OutlinedButton(
                key: const Key('filterTo'),
                onPressed: () => _pick(false),
                child: Text(f.to == null ? 'To' : 'To ${shortDate(f.to!)}')),
            if (f.from != null || f.to != null)
              TextButton(
                  onPressed: () => _set(f.copyWith(from: null, to: null)),
                  child: const Text('Clear dates')),
          ]),
          const SectionLabel('Entered'),
          SingleChipSelect(
            group: 'fsource',
            options: const [
              Option(sourceRealtime, 'At the time'),
              Option(sourceReconstructed, 'Remembered afterwards'),
            ],
            selected: f.source,
            onChanged: (v) => _set(f.copyWith(source: v)),
          ),
          SwitchListTile(
            key: const Key('quietOnly'),
            contentPadding: EdgeInsets.zero,
            title: const Text('Only "Nothing notable" days'),
            value: f.quietOnly,
            onChanged: (v) => _set(f.copyWith(quietOnly: v)),
          ),
          const Divider(),
          Text('Bleeding / discharge', style: Theme.of(context).textTheme.titleMedium),
          const SectionLabel('Colour'),
          MultiChipSelect(
            group: 'fcolour',
            options: fluidColours,
            selected: f.colours.toList(),
            onChanged: (v) => _set(f.copyWith(colours: v.toSet())),
          ),
          const SectionLabel('Amount'),
          MultiChipSelect(
            group: 'famount',
            options: fluidAmounts,
            selected: f.amounts.toList(),
            onChanged: (v) => _set(f.copyWith(amounts: v.toSet())),
          ),
          const SectionLabel('Texture'),
          MultiChipSelect(
            group: 'ftexture',
            options: fluidTextures,
            selected: f.textures.toList(),
            onChanged: (v) => _set(f.copyWith(textures: v.toSet())),
          ),
          const SectionLabel('Blood'),
          MultiChipSelect(
            group: 'fblood',
            options: bloodPresenceOptions,
            selected: f.bloodPresence.toList(),
            onChanged: (v) => _set(f.copyWith(bloodPresence: v.toSet())),
          ),
          SwitchListTile(
            key: const Key('clotPresent'),
            contentPadding: EdgeInsets.zero,
            title: const Text('Clot noticed'),
            value: f.clotPresent,
            onChanged: (v) => _set(f.copyWith(clotPresent: v)),
          ),
          const SectionLabel('Clot size'),
          MultiChipSelect(
            group: 'fclot',
            options: clotSizes,
            selected: f.clotSizes.toList(),
            onChanged: (v) => _set(f.copyWith(clotSizes: v.toSet())),
          ),
          const Divider(),
          const SectionLabel('Libido'),
          MultiChipSelect(
            group: 'flibido',
            options: libidoDirections,
            selected: f.libidoDirections.toList(),
            onChanged: (v) => _set(f.copyWith(libidoDirections: v.toSet())),
          ),
          const SectionLabel('Mood'),
          MultiChipSelect(
            group: 'fmood',
            options: moodCategories,
            selected: f.moodCategories.toList(),
            onChanged: (v) => _set(f.copyWith(moodCategories: v.toSet())),
          ),
          const SectionLabel('Physical symptom'),
          MultiChipSelect(
            group: 'fsymptom',
            options: physicalSymptomTypes,
            selected: f.symptomTypes.toList(),
            onChanged: (v) => _set(f.copyWith(symptomTypes: v.toSet())),
          ),
        ],
      ),
    );
  }
}
