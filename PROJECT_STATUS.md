# Project status

Last updated: milestone 1 (data layer).

## Completed
- M1: Android-only Flutter scaffold, Drift/SQLite schema, controlled vocabularies,
  local-date helpers, day-status derivation, repository, 21 unit tests.

## Currently working
- M2: theme, navigation shell, calendar, daily detail, "Nothing notable today".

## Not yet implemented (planned order)
3. Fluid observation form (multiple per day)
4. Libido / mood / symptom events, edit + delete with undo
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
