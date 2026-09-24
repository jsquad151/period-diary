import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/calendar_screen.dart';
import 'screens/catchup_screen.dart';
import 'screens/context_screens.dart';
import 'screens/day_screen.dart';
import 'screens/event_forms.dart';
import 'screens/fluid_form_screen.dart';
import 'screens/placeholder_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/timeline_screen.dart';
import 'theme.dart';

GoRouter createRouter() => GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _Shell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/', builder: (_, _) => const CalendarScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/timeline',
              builder: (_, _) => const TimelineScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/insights',
              builder: (_, _) => const PlaceholderScreen(title: 'Insights')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/search',
              builder: (_, _) => const SearchScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/settings',
              builder: (_, _) => const SettingsScreen()),
        ]),
      ],
    ),
    GoRoute(path: '/catchup', builder: (_, _) => const CatchUpScreen()),
    GoRoute(
      path: '/context',
      builder: (_, _) => const ContextListScreen(),
      routes: [
        GoRoute(
          path: 'edit',
          builder: (_, state) =>
              ContextFormScreen(editId: state.uri.queryParameters['id']),
        ),
      ],
    ),
    GoRoute(
      path: '/day/:date',
      builder: (_, state) => DayScreen(date: state.pathParameters['date']!),
      routes: [
        GoRoute(
          path: 'fluid',
          builder: (_, state) => FluidFormScreen(
            date: state.pathParameters['date']!,
            editId: state.uri.queryParameters['id'],
          ),
        ),
        GoRoute(
          path: 'libido',
          builder: (_, state) => LibidoFormScreen(
            date: state.pathParameters['date']!,
            editId: state.uri.queryParameters['id'],
          ),
        ),
        GoRoute(
          path: 'mood',
          builder: (_, state) => MoodFormScreen(
            date: state.pathParameters['date']!,
            editId: state.uri.queryParameters['id'],
          ),
        ),
        GoRoute(
          path: 'symptom',
          builder: (_, state) => SymptomFormScreen(
            date: state.pathParameters['date']!,
            editId: state.uri.queryParameters['id'],
          ),
        ),
      ],
    ),
  ],
);

class CycleTrackerApp extends ConsumerStatefulWidget {
  const CycleTrackerApp({super.key});

  @override
  ConsumerState<CycleTrackerApp> createState() => _CycleTrackerAppState();
}

class _CycleTrackerAppState extends ConsumerState<CycleTrackerApp> {
  final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cycle & Symptom Tracker',
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      routerConfig: _router,
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Calendar'),
          NavigationDestination(
              icon: Icon(Icons.view_timeline_outlined),
              selectedIcon: Icon(Icons.view_timeline),
              label: 'Timeline'),
          NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights),
              label: 'Insights'),
          NavigationDestination(
              icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings'),
        ],
      ),
    );
  }
}
