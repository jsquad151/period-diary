import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'database.dart';
import 'date_utils.dart';
import 'entries.dart';
import 'insights.dart';
import 'vocab.dart';

/// Everything the printable summary contains (brief §65). Purely descriptive:
/// it lists what was recorded and never diagnoses or interprets.
class ReportData {
  ReportData({
    required this.from,
    required this.to,
    required this.generatedOn,
    required this.coverage,
    required this.bleedingEntries,
    required this.redBloodDays,
    required this.clotEntries,
    required this.symptomEntries,
    required this.moodLibidoEntries,
    required this.contexts,
  });

  final String from;
  final String to;
  final String generatedOn;
  final Insights coverage;
  final List<DayEntry> bleedingEntries; // oldest first
  final List<String> redBloodDays;
  final List<DayEntry> clotEntries;
  final List<DayEntry> symptomEntries;
  final List<DayEntry> moodLibidoEntries;
  final List<ContextEvent> contexts;
}

ReportData buildReportData({
  required String from,
  required String to,
  required String generatedOn,
  required Insights coverage,
  required Iterable<FluidObservation> fluids,
  required Iterable<LibidoEvent> libidos,
  required Iterable<MoodEvent> moods,
  required Iterable<PhysicalSymptom> symptoms,
  required Iterable<ContextEvent> contexts,
}) {
  bool inRange(String d) => d.compareTo(from) >= 0 && d.compareTo(to) <= 0;
  List<DayEntry> sorted(Iterable<DayEntry> e) => e.toList()
    ..sort((a, b) {
      final c = a.localDate.compareTo(b.localDate);
      return c != 0 ? c : compareEntries(a, b);
    });

  final fl = fluids.where((f) => inRange(f.localDate)).toList();
  return ReportData(
    from: from,
    to: to,
    generatedOn: generatedOn,
    coverage: coverage,
    bleedingEntries: sorted(fl.map(entryFromFluid)),
    redBloodDays: (fl
            .where((f) => f.colours.any(redColours.contains) || f.bloodPresence == 'definite')
            .map((f) => f.localDate)
            .toSet()
            .toList())
        ..sort(),
    clotEntries: sorted(fl.where((f) => f.clot != null).map(entryFromFluid)),
    symptomEntries:
        sorted(symptoms.where((s) => inRange(s.localDate)).map(entryFromSymptom)),
    moodLibidoEntries: sorted([
      ...moods.where((m) => inRange(m.localDate)).map(entryFromMood),
      ...libidos.where((l) => inRange(l.localDate)).map(entryFromLibido),
    ]),
    contexts: contexts
        .where((c) => c.dateStart.compareTo(to) <= 0 && (c.dateEnd ?? c.dateStart).compareTo(from) >= 0)
        .toList()
      ..sort((a, b) => a.dateStart.compareTo(b.dateStart)),
  );
}

/// The built-in PDF fonts only cover Latin-1, so swap typographic characters.
String _pdfSafe(String s) => s
    .replaceAll('–', '-')
    .replaceAll('—', '-')
    .replaceAll('·', '-')
    .replaceAll('’', "'")
    .replaceAll('“', '"')
    .replaceAll('”', '"');

String entryLine(DayEntry e) {
  final parts = <String>[
    shortDate(e.localDate),
    if (e.localTime != null) e.localTime!,
    '${e.title}${e.lines.isEmpty ? '' : ': ${e.lines.join(' | ')}'}',
    if (e.notes != null) 'Note: ${e.notes}',
    if (e.reconstructed) '(remembered afterwards)',
  ];
  return parts.join('  ');
}

Future<Uint8List> renderReportPdf(ReportData r) async {
  final doc = pw.Document(title: 'Symptom and cycle observations', author: 'Cycle & Symptom Tracker');

  pw.Widget heading(String t) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 14, bottom: 4),
        child: pw.Text(_pdfSafe(t),
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
      );

  List<pw.Widget> list(List<String> lines, {String empty = 'None recorded.'}) => lines.isEmpty
      ? [pw.Text(empty, style: const pw.TextStyle(fontSize: 10))]
      : [
          for (final l in lines)
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 3),
              child: pw.Text(_pdfSafe(l), style: const pw.TextStyle(fontSize: 10)),
            ),
        ];

  final c = r.coverage;
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(36),
    footer: (ctx) => pw.Text(
      _pdfSafe('Personal record of observations, not a diagnosis. Page ${ctx.pageNumber} of ${ctx.pagesCount}.'),
      style: const pw.TextStyle(fontSize: 8),
    ),
    build: (ctx) => [
      pw.Text('Symptom and cycle observations',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      pw.Text(_pdfSafe('${prettyDate(r.from)} to ${prettyDate(r.to)}  (prepared ${shortDate(r.generatedOn)})'),
          style: const pw.TextStyle(fontSize: 10)),
      pw.Text(
        'These are the person\'s own recorded observations. Days with no record '
        'are unknown, not normal.',
        style: const pw.TextStyle(fontSize: 9),
      ),
      heading('Tracking coverage'),
      ...list([
        'Days with notable observations: ${c.notableDays}',
        'Days marked "nothing notable": ${c.confirmedQuietDays}',
        'Days with no record: ${c.unobservedDays}',
      ]),
      heading('Bleeding / discharge observations (chronological)'),
      ...list([for (final e in r.bleedingEntries) entryLine(e)]),
      heading('Days with visible red blood'),
      ...list(r.redBloodDays.isEmpty
          ? []
          : [r.redBloodDays.map(shortDate).join(', ')]),
      heading('Clot observations'),
      ...list([for (final e in r.clotEntries) entryLine(e)]),
      heading('Pain and physical symptoms'),
      ...list([for (final e in r.symptomEntries) entryLine(e)]),
      heading('Notable mood and libido observations'),
      ...list([for (final e in r.moodLibidoEntries) entryLine(e)]),
      heading('Health context'),
      ...list([
        for (final e in r.contexts)
          '${describeDateEstimate(e.datePrecision, e.dateStart, e.dateEnd)}  ${e.title} '
              '(${labelFor(contextEventTypes, e.type)})${e.notes == null ? '' : ' - ${e.notes}'}',
      ]),
    ],
  ));
  return doc.save();
}
