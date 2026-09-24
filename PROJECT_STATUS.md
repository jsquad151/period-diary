# Project status

Last updated: milestone 4 (libido, mood, symptoms).

## Completed
- M1: scaffold, Drift schema, vocabularies, date helpers, day-status logic, repository, unit tests.
- M2: theme, bottom navigation, calendar with icon markers, daily detail, "Nothing notable today" (+undo), daily note, widget tests.
- M3: fluid observation form (chips, clot detail, multiple per day), entry list with edit, delete + undo, widget tests.
- M4: libido, mood, physical-symptom forms (pain details only for pain symptoms); prototype journey test incl. close/reopen persistence.

## Currently working
- M5: catch-up flow, historical entries, context events.

## Not yet implemented (planned order)
5. Catch-up flow, reconstructed/historical entries, context events
6. Timeline, search and filters
7. JSON + CSV export, JSON import/restore, delete-all
8. Descriptive insights, PDF report, optional daily reminder
9. Widget + integration tests, release APK

## Known bugs
- none yet

## Decisions requiring product-owner review
- Period *predictions* are deferred to V2 (brief §6/§58); V1 gets an optional
  daily check-in reminder instead.
- A daily note counts as a "notable entry" for day status.
- A "Nothing notable" check-in row is kept when events are added (events win in
  the display); deleting the only event restores the quiet day.

## Dev environment notes
- The Flutter SDK path contains a space, which breaks native-asset build hooks
  (`flutter test` fails). A junction `C:\flutter_sdk` points at the SDK; run
  `C:\flutter_sdk\bin\flutter.bat test` (and build) via that path.
- Java 17 (Temurin) is configured via `flutter config --jdk-dir`.
