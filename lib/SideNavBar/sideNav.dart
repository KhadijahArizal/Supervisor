// ignore_for_file: use_build_context_synchronously, camel_case_types, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supervisor/Screen/Monthly/listMonthly.dart';
import 'package:supervisor/Screen/FinalReport/listFinal.dart';
import 'package:supervisor/Service/auth_service.dart';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false));

class sideNav extends StatelessWidget {
  const sideNav({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return Drawer(
      backgroundColor: Colors.white,
      child: Material(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 146, 143, 10),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Center the items horizontally
                children: [
                  Image.asset(
                    'assets/iium.png', // Your image asset
                    height: 50, // Adjust the height as needed
                    width: 50, // Adjust the width as needed
                  ),
                  const SizedBox(
                      width: 10), // Add spacing between the image and text
                  const Text(
                    'i-KICT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Futura',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            buildMenuItem(
                text: 'Summary',
                icon: Icons.dashboard_rounded,
                onClicked: () => selectedItem(context, 0)),
            const SizedBox(height: 10),
            buildMenuItem(
                text: 'Student Monthly Report',
                icon: Icons.description_rounded,
                onClicked: () => selectedItem(context, 1)),
            const SizedBox(height: 10),
            buildMenuItem(
                text: 'Student Final Report',
                icon: Icons.insert_drive_file_rounded,
                onClicked: () => selectedItem(context, 2)),
            const SizedBox(height: 10),
            const Divider(thickness: 1),
            buildMenuItem(
              text: 'Logout',
              icon: Icons.exit_to_app_rounded,
              onClicked: () async {
                try {
                  await authService.handleSignOut();
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/signIn');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('YEAYY! Logout'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  print("Error during logout: $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    const hoverColor = Colors.white70;

    return ListTile(
        leading: Icon(
          icon,
          color: const Color.fromRGBO(0, 146, 143, 10),
        ),
        title: Text(
          text,
          style: const TextStyle(color: Colors.black87, fontFamily: 'Futura'),
        ),
        hoverColor: hoverColor,
        onTap: onClicked);
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/summary');
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const listOfStudentMonthly(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const listOfStudentFinal(),
        ));
        break;
    }
  }
}
