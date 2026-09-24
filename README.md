# Cycle & Symptom Tracker

A private, offline Android app for recording what you observe (bleeding, discharge,
symptoms, mood, libido) without having to decide what it *means*. Built with Flutter.
Personal use only: it is installed directly on a phone and is not published anywhere.

## What the app is

The core idea: **record what I can observe; don't make me explain what it means.**

- You are never asked "is this your period?". You record what you noticed: colour,
  amount, texture, whether there was blood ("I don't know" is a valid answer).
- Several observations per day are fine.
- **Nothing notable today** is one tap. A day marked that way is different from a day
  with no entry: a blank day means *unknown*, never *normal*.
- Mood and libido are *exception* events ("unusually high libido"), not daily ratings.
- Nothing is diagnosed or predicted. Insights are plain counts of what was recorded.

Screens: Calendar (home), Daily detail, Catch-up, Timeline, Insights, Search + filters,
Settings (health-context events, reminder, export/import, delete all).

## How to run it

One-time setup is already done on this PC (Flutter, Android SDK, JDK 17). Notes:

- The Flutter SDK path contains a space, which breaks native build hooks. Use the
  space-free link `C:\flutter_sdk` (a junction to the real SDK):
  `C:\flutter_sdk\bin\flutter.bat <command>`.
- Java 17 is set with `flutter config --jdk-dir`.

Common commands (from the project folder):

```powershell
C:\flutter_sdk\bin\flutter.bat pub get
C:\flutter_sdk\bin\flutter.bat run                      # to a USB-connected phone with USB debugging on
C:\flutter_sdk\bin\flutter.bat build apk --release --split-per-abi
```

The release build produces `build\app\outputs\flutter-apk\app-arm64-v8a-release.apk`.
Copy that file to the phone and open it to install (allow "install unknown apps" for
whatever app you open it from). Updating over an existing install keeps your data, as
long as the app is built on this same PC (same signing key).

After changing the database tables (`lib/data/database.dart`), regenerate code:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

## How to test it

```powershell
C:\flutter_sdk\bin\flutter.bat analyze
C:\flutter_sdk\bin\flutter.bat test
```

Tests cover: date handling around midnight, day-status rules, the repository, catch-up
logic, filters, timeline, insights, backup export/import (including rejecting bad
files), CSV output, PDF generation, and widget tests for every screen including the
"first prototype" journey (add observations, mark a quiet day, close and reopen, data
still there). These run on the desktop test runner, not on a phone.

## How data is stored

- A SQLite database file (`cycle_tracker.sqlite`) in the app's private storage, managed
  with Drift. Nothing leaves the phone: no account, no analytics, no network calls.
- Calendar dates are stored as plain `YYYY-MM-DD` text (never converted through UTC), so
  a 23:59 entry stays on its day. Times are optional `HH:mm`.
- Raw observations, the daily "Nothing notable" check-in, and notes are separate tables.
  A day's status (unobserved / confirmed quiet / has notable entries) is *derived*.
- Choices (colours, textures...) are stored as stable text keys; labels live in
  `lib/data/vocab.dart`. Don't rename a key once data exists.
- Uninstalling the app deletes its data. Android may also skip app data when restoring a
  new phone. **Export a backup regularly.**

## Export, import and delete

Settings > Your data:

- **Export backup (JSON)**: lossless copy of everything, with a `schemaVersion`. Choose
  where to save it (Downloads, Drive...). Settings shows when you last did this.
- **Export as spreadsheets (CSV)**: one readable file per record type, via the share
  sheet.
- **Import from backup**: the file is fully validated first; nothing is written unless
  the whole file is valid. You see a preview (how many records are new vs already
  here), then choose **Add what's missing** (existing records are never overwritten) or
  **Replace everything** (wipes the phone's data first). It is all-or-nothing.
- **Delete all data**: requires typing "delete". You can export first from the same
  dialog.
- **Insights > Create a printable summary (PDF)**: a doctor-friendly summary of the
  chosen range (coverage, bleeding/discharge, red-blood days, clots, symptoms,
  mood/libido, health context). Descriptive only.

## Project architecture

```
lib/
  main.dart            app start, opens the database, re-arms the reminder
  app.dart             routes (go_router) and bottom navigation
  providers.dart       Riverpod providers (database streams, derived summaries)
  theme.dart           calm Material 3 theme
  data/
    database.dart      Drift tables (+ database.g.dart generated)
    vocab.dart         controlled vocabularies (keys + labels)
    repository.dart    all writes (save/delete/restore); UI never touches SQL
    day_status.dart    the three-state day model and per-day summaries
    entries.dart       display-ready descriptions of events
    filter.dart        search filters (pure)
    timeline.dart      timeline builder (pure)
    catchup.dart       which days to offer for catch-up (pure)
    insights.dart      descriptive statistics (pure)
    backup.dart        JSON export/validate/import, CSV
    report.dart        PDF summary
    reminders.dart     reminder interface + settings;  local_reminders.dart = real notifications
    file_gateway.dart  the only place touching file pickers / share sheet
  screens/, widgets/   UI
test/                  unit + widget tests (test/data, test/screens)
```

Design rules that are architecture, not preference (from the product brief): observation
is not interpretation; no entry is not "normal"; "Nothing notable" is not "nothing
happened"; predictions never overwrite observations.

## Important design decisions

- **Android only**, no web/PWA. A native app installed directly (no store).
- **Drift/SQLite** instead of IndexedDB; **Riverpod** for state; **go_router** for navigation.
- **No period predictions in V1** (the brief defers them). The optional daily reminder
  just says "Anything notable today?" so nothing health-related appears on a lock screen.
- Bleeding/symptom observations always belong to an exact day; imprecise dates
  (approximate, range, month only) are supported for health-context events. Entries
  made for a past day are tagged "remembered afterwards".
- Catch-up looks back 7 days, never before the first recorded day, never includes today.
  "I don't remember" leaves the day blank and doesn't ask again.
- A daily note counts as a recorded entry for that day's status.
- Release builds have code shrinking off, to avoid plugin breakage.
- File access goes through one small gateway so it can be replaced in tests.

## Known limitations

- **Not yet run on a physical phone.** All automated tests run on the desktop test
  runner; nothing here could be tried on an Android device or emulator during
  development. The first install is the first real-device test, so please look
  especially at: saving/opening files (backup, import, CSV/PDF sharing), the reminder
  permission prompt, and how the calendar and forms look and feel on the real screen.
- The reminder uses an inexact alarm: it may arrive a few minutes late. Some phone
  makers' battery savers can suppress it.
- The app's data lives only on the phone; there is no automatic backup (by design).
- Signed with the debug key (fine for personal use).
- Episode grouping exists in the database and exports but has no screen yet.
- Text search covers notes only.

## Future-version ideas

- V1.1: saved filters, custom tags, charts, optional encrypted backup, photos.
- V2: cycle inference: probable menstrual episodes, Day-1 ranges, prediction *ranges*
  with confidence, all clearly separated from the raw observations.
- V3: cycle physiology (basal temperature, LH tests, cervical mucus, phase estimates).
- V4: personal longitudinal analysis (associations between mood, libido, symptoms and bleeding).
