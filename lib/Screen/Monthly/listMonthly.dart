// ignore_for_file: camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/Screen/StudentList/studentDetails.dart';
import 'package:supervisor/Screen/common/models.dart';
import 'package:supervisor/SideNavBar/sideNav.dart';

class listOfStudentMonthly extends StatefulWidget {
  const listOfStudentMonthly({Key? key}) : super(key: key);

  @override
  State<listOfStudentMonthly> createState() => _listOfStudentMonthlyState();
}

class _listOfStudentMonthlyState extends State<listOfStudentMonthly> {
  User? user = FirebaseAuth.instance.currentUser;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late DatabaseReference _iapFormRef;
  late DatabaseReference _monthlyReport;
  late List<UserDataC> userData = [];
  List<MonthlyReportC> monthlyReports = [];
  late DatabaseReference _supervisorRef;
  List<UserDataC> originalUserData = [];
  late DatabaseReference _monthlyReportCountsRef;

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
    _fetchUserData();
    _monthlyReportCountsRef = FirebaseDatabase.instance
        .ref()
        .child('Supervisor')
        .child('Total Monthly Report')
        .child(userId);
  }

  Future<void> _fetchUserData() async {
    try {
      String supervisorEmail = '${user?.email}';
      DataSnapshot iapSnapshot =
          await _iapFormRef.once().then((event) => event.snapshot);
      DataSnapshot monthlyReportSnapshot =
          await _monthlyReport.once().then((event) => event.snapshot);
      DataSnapshot svReportSnapshot =
          await _supervisorRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? iapData =
          iapSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? monthlyReportData =
          monthlyReportSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? svReportData =
          svReportSnapshot.value as Map<dynamic, dynamic>?;

      if (iapData != null &&
          monthlyReportData != null &&
          svReportData != null) {
        svReportData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> &&
              monthlyReportData.containsKey(key) &&
              iapData.containsKey(key)) {
            //iap
            String matric = iapData[key]['Matric'] ?? '';
            String name = iapData[key]['Name'] ?? '';
            String studentID = iapData[key]['Student ID'] ?? '';

            //svemail
            String svemail = svReportData[key]['Email'] ?? '';

            //monthly
            List<MonthlyReportC> monthlyReports = [];
            if (monthlyReportData[key]['Reports'] is Map) {
              monthlyReportData[key]['Reports']
                  .forEach((reportKey, reportValue) {
                MonthlyReportC monthlyReport = MonthlyReportC(
                  month: reportValue['Month'] ?? '',
                  monthlyRname: reportValue['Name'] ?? '',
                  status: reportValue['Status'] ?? '',
                  date: reportValue['Submission Date'] ?? '',
                  monthlyFile: reportValue['File'] ?? '',
                );
                monthlyReports.add(monthlyReport);
              });
            }
            if (svemail == supervisorEmail) {
              UserDataC user = UserDataC(
                studentID: studentID,
                matric: matric,
                name: name,
                svemail: svemail,
                monthlyReports: monthlyReports,
                finalReport: FinalReportC(
                    date: '',
                    file: '',
                    fileName: '',
                    title: '',
                    status: '',
                    statusSV: ''),
              );

              userData.add(user);
              originalUserData.add(user);
            }

            print('userData: $userData');
          }
        });
        await _calculateAndStoreReportCounts();
      }

      setState(() {});
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  List<UserDataC> _filterUserData(String searchValue) {
    return userData
        .where((user) =>
            user.matric.toLowerCase().contains(searchValue.toLowerCase()))
        .toList();
  }

  Future<void> _calculateAndStoreReportCounts() async {
    int totalStudents = userData.length;

    int pendingCount = 0;
    int approvedCount = 0;
    int rejectedCount = 0;

    for (UserDataC user in userData) {
      for (MonthlyReportC report in user.monthlyReports) {
        if (report.status == 'Pending') {
          pendingCount++;
        } else if (report.status == 'Approved') {
          approvedCount++;
        } else if (report.status == 'Rejected') {
          rejectedCount++;
        }
      }
    }

    try {
      await _monthlyReportCountsRef.set({
        'totalStudents': totalStudents,
        'pendingCount': pendingCount,
        'approvedCount': approvedCount,
        'rejectedCount': rejectedCount,
      });

      print('Monthly report counts stored successfully.$totalStudents $pendingCount $approvedCount $rejectedCount');
    } catch (error) {
      print('Error storing monthly report counts: $error');
    }
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
          'Monthly Report Status',
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
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            // If the search value is empty, reset to the original data
                            userData = originalUserData;
                          } else {
                            // Otherwise, filter the data based on the search value
                            userData = _filterUserData(value);

                            // Check if there are no students matching the search
                            if (userData.isEmpty) {
                              userData.add(UserDataC(
                                // You can customize this message or leave fields empty as needed
                                name: 'No student found',
                                matric: '',
                                studentID: '',
                                svemail: '',
                                monthlyReports: [],
                                finalReport: FinalReportC(
                                  date: '',
                                  file: '',
                                  fileName: '',
                                  title: '',
                                  status: '',
                                  statusSV: '',
                                ),
                              ));
                            }
                          }
                        });
                      },
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
                        prefixIconColor: Colors.grey,
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
                          : const Center(
                              child: Text(
                                'No students found.',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                    ),
                  ],
                ))),
      ),
    );
  }
}
