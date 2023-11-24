import 'package:flutter/material.dart';
import 'package:supervisor/Screen/Announcements/announcements.dart';
import 'package:supervisor/Screen/StudentList/studentDetails.dart';
import 'package:supervisor/Screen/Summary.dart';
import 'package:supervisor/Screen/StudentList/studentList.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/summary',
      routes: {
        //'/':(context) => A(),
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
