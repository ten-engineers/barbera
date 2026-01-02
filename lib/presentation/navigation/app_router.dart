import 'package:go_router/go_router.dart';
import '../screens/practice_screen.dart';
import '../screens/add_word_screen.dart';
import '../screens/stats_screen.dart';
import '../widgets/bottom_nav_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/practice',
  routes: [
    GoRoute(
      path: '/practice',
      builder: (context, state) => _ScaffoldWithNavBar(
        child: const PracticeScreen(),
        currentLocation: '/practice',
      ),
    ),
    GoRoute(
      path: '/add-word',
      builder: (context, state) => _ScaffoldWithNavBar(
        child: const AddWordScreen(),
        currentLocation: '/add-word',
      ),
    ),
    GoRoute(
      path: '/stats',
      builder: (context, state) => _ScaffoldWithNavBar(
        child: const StatsScreen(),
        currentLocation: '/stats',
      ),
    ),
  ],
);

class _ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const _ScaffoldWithNavBar({
    required this.child,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(currentLocation: currentLocation),
    );
  }
}

