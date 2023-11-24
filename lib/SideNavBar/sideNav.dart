import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/Screen/settings.dart';
import 'package:supervisor/Screen/studentFinalReport.dart';
import 'package:supervisor/Screen/Monthly/studentMonthlyReport.dart';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false));

class sideNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Material(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(148, 112, 18, 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Center the items horizontally
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
                text: 'Student Monthly Report',
                icon: Icons.book,
                onClicked: () => selectedItem(context, 0)),
            const SizedBox(height: 10),
            buildMenuItem(
                text: 'Student Final Report',
                icon: Icons.insert_drive_file_rounded,
                onClicked: () => selectedItem(context, 1)),
                const SizedBox(height: 10),
                buildMenuItem(
                text: 'Settings',
                icon: Icons.settings_rounded,
                onClicked: () => selectedItem(context, 2)),
            const Spacer(),
            const Divider(
              color: Colors.black54,
            ),
            buildMenuItem(
              text: 'Logout',
              icon: Icons.exit_to_app_rounded,
              onClicked: () => SystemNavigator.pop(),
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
          color: const Color.fromRGBO(148, 112, 18, 10),
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
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SMonthlyReport(title:  'Student Monthly Report',),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SFinalReport(title: 'Student Final Report',),
        ));
        break;
        case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Settings(title: 'Settings',),
        ));
        break;
    }
  }
}
