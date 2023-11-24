import 'package:flutter/material.dart';
import 'package:supervisor/Screen/summary.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Colors.white30.withOpacity(0.2), BlendMode.dstATop),
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
                            color: Color.fromRGBO(148, 112, 18, 1),
                            fontSize: 60,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Playfair Display',
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Industrial Attachment Programme Dashboard',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'Futura',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                  Form(
                      child: Column(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50)
                        ),
                        onPressed: (){
                      }, icon:const Icon(Icons.login, color: Colors.red), label: const Text('Sign Up with Google')),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Email', border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Pass', border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Summary(
                                            title: '',
                                          )));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(148, 112, 18, 1),
                                  minimumSize: const Size(double.infinity, 50)
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Futura'),
                            ))
                    ],
                  ))
                ],
              )),
        ));
  }
}
