import 'package:flutter/material.dart';

import '../data/vocab.dart';

/// Multi-select chips over a controlled vocabulary.
class MultiChipSelect extends StatelessWidget {
  const MultiChipSelect({
    super.key,
    required this.group,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final String group;
  final List<Option> options;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          FilterChip(
            key: Key('chip-$group-${o.key}'),
            label: Text(o.label),
            selected: selected.contains(o.key),
            showCheckmark: true,
            onSelected: (on) {
              final next = [...selected];
              on ? next.add(o.key) : next.remove(o.key);
              // Keep vocabulary order so exports/summaries are stable.
              next.sort((a, b) => options
                  .indexWhere((x) => x.key == a)
                  .compareTo(options.indexWhere((x) => x.key == b)));
              onChanged(next);
            },
          ),
      ],
    );
  }
}

/// Single-select chips; tapping the selected chip clears it (unless [required]).
class SingleChipSelect extends StatelessWidget {
  const SingleChipSelect({
    super.key,
    required this.group,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.required = false,
  });

  final String group;
  final List<Option> options;
  final String? selected;
  final ValueChanged<String?> onChanged;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          ChoiceChip(
            key: Key('chip-$group-${o.key}'),
            label: Text(o.label),
            selected: selected == o.key,
            showCheckmark: true,
            onSelected: (on) {
              if (on) {
                onChanged(o.key);
              } else if (!required) {
                onChanged(null);
              }
            },
          ),
      ],
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      );
}
