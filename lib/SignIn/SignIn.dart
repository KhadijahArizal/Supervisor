// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supervisor/Screen/summary.dart';
import 'package:supervisor/Service/auth_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService authService = AuthService();
  bool isSignedIn = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            'Supervisor Dashboard',
            style: TextStyle(
                color: Colors.black38, fontSize: 15, fontFamily: 'Futura'),
            textAlign: TextAlign.right,
          )
        ]),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 25,
            color: Color.fromRGBO(0, 146, 143, 10),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/auth');
          },
        ),
      ),
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: const AssetImage('assets/iiumlogo.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white30.withOpacity(0.2),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    padding: const EdgeInsets.all(70),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/iium.png')),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'I-KICT',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 146, 143, 10),
                      fontSize: 60,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Industrial Attachment Programme Supervisor Dashboard',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontFamily: 'Futura',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            _isLoading = true;
                          });

                          User? user = await authService.handleSignIn();

                          if (user != null) {
                            // User successfully signed in
                            setState(() {
                              isSignedIn = true;
                              _isLoading = false;
                            });

                            if (await authService.isSignInResultValid(user)) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const Summary(title: 'Summary'),
                                ),
                              );
                            } else {
                              // Handle the case where the sign-in result is not valid
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Google Sign-In failed. Please try again.'),
                                ),
                              );
                            }
                          } else {
                            // User canceled sign-in
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        } catch (e) {
                          // Handle other sign-in errors
                          print('Error signing in: $e');
                          setState(() {
                            _isLoading = false;
                          });

                          // Check if the error message contains information about the popup being closed
                          if (e.toString().contains('popup_closed')) {
                            // Handle the case where the Google Sign-In popup is closed by the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Google Sign-In popup closed. Please try again.'),
                              ),
                            );
                          } else if (e
                              .toString()
                              .contains('your_error_message_or_code')) {
                            // Handle other sign-in errors
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Sign-in failed. Please try again.'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(10),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/google.png',
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Sign In with Google',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Futura',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isLoading) const CircularProgressIndicator()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
