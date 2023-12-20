import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supervisor/Screen/Announcements/announcements.dart';
import 'package:supervisor/Screen/StudentList/studentDetails.dart';
import 'package:supervisor/Screen/Summary.dart';
import 'package:supervisor/Screen/StudentList/studentList.dart';
import 'package:supervisor/Start/logo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyCBKu3YXVESBwuucKGqRKVYKxtqD34rJhs',
    appId: '1:245036400102:android:165e6660046618547a6a27',
    messagingSenderId: '245036400102',
    projectId: 'ikict-supervisor',
    databaseURL: 'https://ikict-supervisor-default-rtdb.firebaseio.com/',
    authDomain: 'ikict-supervisor.firebaseapp.com.',
  ));
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/summary',
      routes: {
       // '/': (context) => SplashScreen(),
        '/summary': (context) => const Summary(title: 'Summary'),
        '/student_list': (context) =>
            const StudentList(title: 'List of Students'),
        '/announc': (context) => const Announc(title: 'Announcements'),
        '/student_details': (context) => const StudentDetails(
              title: 'Student Details',
              studentName: '',
              Matric: '',
              status: '',
            ),
        //'/monthly': (context) => const SMonthlyReport(title: 'Student Monthly Report'),
      },
    ),
  );
}
