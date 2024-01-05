import 'package:flutter/material.dart';
import 'package:supervisor/Start/start.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(context, _createRoute());
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Start(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('assets/iium.png'), // Replace with your logo image
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
