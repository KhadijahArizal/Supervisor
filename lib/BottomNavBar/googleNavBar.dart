import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class GNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChange;

  GNavbar({required this.currentIndex, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // Change shadow color
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: GNav(
          color: Colors.grey, // Change icon color to white
          activeColor: Colors.white, // Change active color
          tabBackgroundColor: const Color.fromRGBO(0, 146, 143, 10),
          gap: 10,
          selectedIndex: currentIndex,
          onTabChange: onTabChange,
          tabs: const [
            GButton(
              icon: Icons.dashboard_rounded,
              text: 'Summary',
              iconSize: 30,
              textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white), 
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
            ),
            GButton(
              icon: Icons.list_alt_rounded,
              text: 'List Of Students',
              iconSize: 30,
              textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white), 
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            GButton(
              icon: Icons.upload_rounded,
              text: 'Announcements',
              iconSize: 30,
              textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white), // Change text color to white
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ],
        ),
      ),
    );
  }
}
