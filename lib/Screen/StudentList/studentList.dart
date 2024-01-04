// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names, use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/BottomNavBar/googleNavBar.dart';
import 'package:supervisor/Screen/StudentList/studentDetails.dart';
import 'package:supervisor/Screen/common/models.dart';
import 'package:supervisor/Screen/summary.dart';
import 'package:supervisor/SideNavBar/sideNav.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  User? user = FirebaseAuth.instance.currentUser;
  late DatabaseReference _supervisorRef;
  late DatabaseReference _iapFormRef;
  late DatabaseReference _monthlyReport;
  late DatabaseReference _finalReport;
  late List<UserData> userData = [];
  List<MonthlyReport> monthlyReports = [];

  @override
  void initState() {
    super.initState();
    _supervisorRef =
        FirebaseDatabase.instance.ref('Student').child('Supervisor Details');
    _iapFormRef =
        FirebaseDatabase.instance.ref().child('Student').child('IAP Form');
    _monthlyReport = FirebaseDatabase.instance
        .ref()
        .child('Student')
        .child('Monthly Report');
    _finalReport =
        FirebaseDatabase.instance.ref().child('Student').child('Final Report');
    _fetchUserData();
  }

  void _navigateToDashboard(int totalStudents) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Summary(
          totalStudents: totalStudents,
          title: 'Summary',
        ),
      ),
    );
  }

  Future<void> _fetchUserData() async {
    try {
      String supervisorEmail = '${user?.email}';
      DataSnapshot iapSnapshot =
          await _iapFormRef.once().then((event) => event.snapshot);
      DataSnapshot monthlyReportSnapshot =
          await _monthlyReport.once().then((event) => event.snapshot);
      DataSnapshot finalReportSnapshot =
          await _finalReport.once().then((event) => event.snapshot);
      DataSnapshot svReportSnapshot =
          await _supervisorRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? iapData =
          iapSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? monthlyReportData =
          monthlyReportSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? finalReportData =
          finalReportSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? svReportData =
          svReportSnapshot.value as Map<dynamic, dynamic>?;

      if (iapData != null && svReportData != null) {
        svReportData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && iapData.containsKey(key)) {
            //iap
            String matric = iapData[key]['Matric'] ?? '';
            String name = iapData[key]['Name'] ?? '';
            String studentID = iapData[key]['Student ID'] ?? '';

            //svemail
            String svemail = svReportData[key]['Email'] ?? '';

            //monthly
            List<MonthlyReport> monthlyReports = [];
            if (monthlyReportData != null &&
                monthlyReportData[key] != null &&
                monthlyReportData[key]['Reports'] is Map) {
              monthlyReportData[key]['Reports']
                  .forEach((reportKey, reportValue) {
                MonthlyReport monthlyReport = MonthlyReport(
                  month: reportValue['Month'] ?? '',
                  monthlyRname: reportValue['Name'] ?? '',
                  status: reportValue['Status'] ?? '',
                  date: reportValue['Submission Date'] ?? '',
                  monthlyFile: reportValue['File'] ?? '',
                );
                monthlyReports.add(monthlyReport);
              });
            }

            //finalReport
            String date = finalReportData?['Date'] ?? '';
            String file = finalReportData?['File'] ?? '';
            String fileName = finalReportData?['File Name'] ?? '';
            String title = finalReportData?['Report Title'] ?? '';
            String status = finalReportData?['Status'] ?? '';

            if (svemail == supervisorEmail) {
              UserData user = UserData(
                //iap
                matric: matric,
                name: name,
                //sv
                svemail: svemail,
                //monthly
                monthlyReports: monthlyReports,
                //final
                finalReport: FinalReport(
                    date: date,
                    file: file,
                    fileName: fileName,
                    title: title,
                    status: status),
                studentID: studentID,
              );

              userData.add(user);
            }
            print('Matric: $matric');
            print('Name: $name');
            print('Monthly Reports: $monthlyReports');
          }
        });
      }
      setState(() {
        int totalStudents = userData.length;
        _navigateToDashboard(totalStudents);
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  int _currentIndex = 1;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, '/summary');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/student_list');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/announc');
      }
    });
  }

  Widget _name({required String name}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontFamily: 'Futura',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget _matricNo({required String matricNo}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            matricNo,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontFamily: 'Futura',
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List of Students',
          style: TextStyle(
              color: Colors.black87,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(0, 146, 143, 10),
          size: 30,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.sort,
                  color: Color.fromRGBO(0, 146, 143, 10), size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const sideNav(),
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            height: double.infinity,
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
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) => {}, //_runFilter(value),
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Search student Matric No",
                        prefixIcon: const Icon(Icons.search_rounded),
                        prefixIconColor: const Color.fromRGBO(0, 146, 143, 0.8),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: userData.isNotEmpty
                          ? ListView.separated(
                              itemCount: userData.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => S_Details(
                                        name: userData[index].name,
                                        matric: userData[index].matric,
                                        studentID: userData[index].studentID,
                                      ),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(1),
                                  title: _name(name: userData[index].name),
                                  subtitle: _matricNo(
                                    matricNo: userData[index].matric,
                                  ),
                                ),
                              ),
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.black26,
                              ),
                            )
                          : const Text(
                              'No results found.',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ],
                ))),
      ),
      bottomNavigationBar: GNavbar(
        currentIndex: _currentIndex,
        onTabChange: onTabTapped,
      ),
    );
  }
}
