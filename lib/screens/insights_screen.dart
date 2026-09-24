import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/date_utils.dart';
import '../data/file_gateway.dart';
import '../data/insights.dart';
import '../data/report.dart';
import '../data/vocab.dart';
import '../providers.dart';
import '../widgets/chip_select.dart';

/// Descriptive statistics only. Nothing here predicts, diagnoses or explains.
class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  String _range = 'all';

  static const _ranges = [
    Option('all', 'All time'),
    Option('90', 'Last 90 days'),
    Option('30', 'Last 30 days'),
  ];

  String? get _from => _range == 'all'
      ? null
      : addDaysToLocalDate(formatLocalDate(DateTime.now()), -(int.parse(_range) - 1));

  Insights _compute() => computeInsights(
        today: formatLocalDate(DateTime.now()),
        from: _from,
        summaries: ref.watch(daySummariesProvider),
        fluids: ref.watch(fluidsProvider).value ?? const [],
        libidos: ref.watch(libidosProvider).value ?? const [],
        moods: ref.watch(moodsProvider).value ?? const [],
        symptoms: ref.watch(symptomsProvider).value ?? const [],
      );

  Future<void> _makeReport(Insights insights) async {
    final today = formatLocalDate(DateTime.now());
    final from = insights.from ?? today;
    final data = buildReportData(
      from: from,
      to: today,
      generatedOn: today,
      coverage: insights,
      fluids: ref.read(fluidsProvider).value ?? const [],
      libidos: ref.read(libidosProvider).value ?? const [],
      moods: ref.read(moodsProvider).value ?? const [],
      symptoms: ref.read(symptomsProvider).value ?? const [],
      contexts: ref.read(contextEventsProvider).value ?? const [],
    );
    final bytes = await renderReportPdf(data);
    await ref.read(fileGatewayProvider).shareFiles([
      GatewayFile('cycle-tracker-report-$today.pdf', bytes, 'application/pdf'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final i = _compute();
    final theme = Theme.of(context);

    Widget card(String title, List<Widget> children) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...children,
                ],
              ),
            ),
          ),
        );

    String plural(int n, String one, [String? many]) => '$n ${n == 1 ? one : (many ?? '${one}s')}';

    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SingleChipSelect(
            group: 'insightRange',
            options: _ranges,
            selected: _range,
            required: true,
            onChanged: (v) => setState(() => _range = v ?? 'all'),
          ),
          const SizedBox(height: 16),
          if (i.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Nothing recorded yet. Once you log some days, simple counts and '
                'patterns of what you recorded will appear here.',
                key: Key('insightsEmpty'),
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            card('Tracking coverage', [
              Text('${shortDate(i.from!)} to ${shortDate(i.to!)}'),
              const SizedBox(height: 4),
              Text('Days with notable observations: ${i.notableDays}', key: const Key('notableDays')),
              Text('Days marked "nothing notable": ${i.confirmedQuietDays}'),
              Text('Days with no record: ${i.unobservedDays}', key: const Key('unobservedDays')),
              const SizedBox(height: 6),
              Text(
                'A day with no record is unknown. It is not counted as normal.',
                style: theme.textTheme.bodySmall,
              ),
            ]),
            card('What was recorded', [
              Text('${plural(i.fluidObservationCount, 'bleeding / discharge observation')} '
                  'across ${plural(i.daysWithFluid, 'day')}'),
              Text(plural(i.highLibido, 'unusually high libido event')),
              Text(plural(i.lowLibido, 'unusually low libido event')),
              for (final e in i.moodCounts.entries)
                Text('${plural(e.value, 'event')}: ${labelFor(moodCategories, e.key)}'),
              for (final e in i.symptomCounts.entries)
                Text('${plural(e.value, 'time')}: ${labelFor(physicalSymptomTypes, e.key)}'),
            ]),
            if (i.longestBrownRun != null || i.shortestGapBetweenRedRuns != null)
              card('Patterns in the record', [
                if (i.longestBrownRun != null)
                  Text('Longest run of days containing brown material: '
                      '${plural(i.longestBrownRun!.length, 'day')} '
                      '(${shortDate(i.longestBrownRun!.start)}'
                      '${i.longestBrownRun!.length > 1 ? ' to ${shortDate(i.longestBrownRun!.end)}' : ''})'),
                if (i.shortestGapBetweenRedRuns != null)
                  Text('Shortest time between separate runs of days with red blood: '
                      '${plural(i.shortestGapBetweenRedRuns!, 'day')}'),
              ]),
            if (i.associations.isNotEmpty)
              card('Things that happened around the same time', [
                for (final a in i.associations)
                  Text('${a.withinWindow} of ${plural(a.total, 'recorded ${a.label} event')} '
                      'fell within ${a.windowDays} days up to and including a day with red blood.'),
                const SizedBox(height: 6),
                Text(
                  'This only counts what was recorded, in the same window. It doesn\'t '
                  'show that one thing caused or predicts another.',
                  style: theme.textTheme.bodySmall,
                ),
              ]),
            const SizedBox(height: 4),
            FilledButton.icon(
              key: const Key('makeReport'),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('Create a printable summary (PDF)'),
              onPressed: () => _makeReport(i),
            ),
            const SizedBox(height: 4),
            Text(
              'Covers the range chosen above. Share it with a doctor if you like.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
