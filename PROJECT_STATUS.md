# Project status

Last updated: milestone 9 (release build, docs).

## Completed
- M1: scaffold, Drift schema, vocabularies, date helpers, day-status logic, repository, unit tests.
- M2: theme, bottom navigation, calendar with icon markers, daily detail, "Nothing notable today" (+undo), daily note, widget tests.
- M3: fluid observation form (chips, clot detail, multiple per day), entry list with edit, delete + undo, widget tests.
- M4: libido, mood, physical-symptom forms (pain details only for pain symptoms); prototype journey test incl. close/reopen persistence.
- M5: catch-up banner + flow (nothing notable / add something / I don't remember), health-context events with approximate dates, Settings screen.
- M6: timeline (newest first, gaps omitted), notes search, filter sheet (colour, amount, texture, blood, clot, libido, mood, symptom, dates, source, quiet days).
- M7: JSON backup export (save dialog), CSV export (share sheet, 7 files), validated transactional import (merge or replace, preview first), typed-confirmation delete-all, last-export indicator.
- M8: descriptive Insights (coverage, counts, brown run, gap between red-blood runs, non-causal associations), PDF summary report, optional daily reminder (bland text, off by default). Fixed Android build (upgraded notifications plugin, enabled desugaring).
- M9: README, release APKs (arm64 23.6 MB), gitignore cleanup, release shrinking disabled for safety.

## Currently working
- Next: install on the phone and try it; fix whatever real-device use turns up.

## Not yet implemented

## Known bugs
- Never run on a real Android device or emulator (none available during development); only desktop-runner tests. First install is the first real test.
- No on-device integration_test yet.
- none yet

## Decisions requiring product-owner review
- Imprecise dates (approximate/range/month) are supported for health-context events; symptom and bleeding observations always belong to an exact calendar day (entered later they are tagged "remembered afterwards").
- Catch-up looks back 7 days, never before the first recorded day, never includes today. "I don't remember" days stay blank but are not asked again.
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
