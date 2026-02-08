import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final String currentLocation;

  const BottomNavBar({
    super.key,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getCurrentIndex(currentLocation),
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/practice');
            break;
          case 1:
            context.go('/add-word');
            break;
          case 2:
            context.go('/all-words');
            break;
          case 3:
            context.go('/stats');
            break;
          case 4:
            context.go('/settings');
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Practice',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'Add Word',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'All Words',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Stats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  int _getCurrentIndex(String location) {
    switch (location) {
      case '/practice':
        return 0;
      case '/add-word':
        return 1;
      case '/all-words':
        return 2;
      case '/stats':
        return 3;
      case '/settings':
        return 4;
      default:
        return 0;
    }
  }
}

