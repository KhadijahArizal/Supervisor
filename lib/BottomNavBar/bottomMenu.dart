import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Map<String, String> routeNames;

  BottomMenu({
    required this.currentIndex,
    required this.onTap,
    required this.routeNames,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: const Color.fromRGBO(148, 112, 18, 1),
      unselectedItemColor: Colors.grey,
      items: routeNames.keys.map((routeName) {
        return BottomNavigationBarItem(
          icon: Column(
            children: [
              InkWell(
                onTap: () => onTap(routeNames.keys.toList().indexOf(routeName)),
                child: Icon(
                  getIconForRoute(routeName),
                  color: currentIndex == routeNames.keys.toList().indexOf(routeName)
                      ? const Color.fromRGBO(148, 112, 18, 1)
                      : Colors.grey,
                ),
              ),
              Text(
                routeName,
                style: TextStyle(
                  color: currentIndex == routeNames.keys.toList().indexOf(routeName)
                      ? const Color.fromRGBO(148, 112, 18, 1)
                      : Colors.grey,
                ),
              ),
            ],
          ),
          label: '', // Clear the label
        );
      }).toList(),
    );
  }

  IconData getIconForRoute(String routeName) {
    switch (routeName) {
      case 'summary':
        return Icons.dashboard;
        case 'student_list':
        return Icons.list_alt;
      case 'announc':
        return Icons.upload;
      default:
        return Icons.dashboard;
    }
  }
}
