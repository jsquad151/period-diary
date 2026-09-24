import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/calendar_screen.dart';
import 'screens/day_screen.dart';
import 'screens/placeholder_screen.dart';
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
              builder: (_, _) => const PlaceholderScreen(title: 'Timeline')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/insights',
              builder: (_, _) => const PlaceholderScreen(title: 'Insights')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/search',
              builder: (_, _) => const PlaceholderScreen(title: 'Search')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/settings',
              builder: (_, _) => const PlaceholderScreen(title: 'Settings')),
        ]),
      ],
    ),
    GoRoute(
      path: '/day/:date',
      builder: (_, state) => DayScreen(date: state.pathParameters['date']!),
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
