// ignore_for_file: camel_case_types, avoid_print, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/Screen/StudentList/studentDetails.dart';
import 'package:supervisor/Screen/common/models.dart';
import 'package:supervisor/SideNavBar/sideNav.dart';

class listOfStudentFinal extends StatefulWidget {
  const listOfStudentFinal({Key? key}) : super(key: key);

  @override
  State<listOfStudentFinal> createState() => _listOfStudentFinalState();
}

class _listOfStudentFinalState extends State<listOfStudentFinal> {
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

  Future<void> _fetchUserData() async {
    try {
      String supervisorEmail = '${user?.email}';
      DataSnapshot iapSnapshot =
          await _iapFormRef.once().then((event) => event.snapshot);
      DataSnapshot monthlyReportSnapshot =
          await _monthlyReport.once().then((event) => event.snapshot);
      DataSnapshot svReportSnapshot =
          await _supervisorRef.once().then((event) => event.snapshot);
      DataSnapshot finalReportSnapshot =
          await _finalReport.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? iapData =
          iapSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? monthlyReportData =
          monthlyReportSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? finalReportData =
          finalReportSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? svReportData =
          svReportSnapshot.value as Map<dynamic, dynamic>?;

      if (iapData != null &&
          monthlyReportData != null &&
          svReportData != null &&
          finalReportData != null) {
        svReportData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> &&
              finalReportData.containsKey(key) &&
              monthlyReportData.containsKey(key) &&
              iapData.containsKey(key)) {
            //iap
            String matric = iapData[key]['Matric'] ?? '';
            String name = iapData[key]['Name'] ?? '';
            String studentID = iapData[key]['Student ID'] ?? '';

            //svemail
            String svemail = svReportData[key]['Email'] ?? '';

            //monthly
            List<MonthlyReport> monthlyReports = [];
            if (monthlyReportData[key]['Reports'] is Map) {
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
            String date = finalReportData[key]['Date'] ?? '';
            String file = finalReportData[key]['File'] ?? '';
            String fileName = finalReportData[key]['File Name'] ?? '';
            String title = finalReportData[key]['Report Title'] ?? '';
            String status = finalReportData[key]['Status'] ?? '';

            if (svemail == supervisorEmail &&
                date.isNotEmpty &&
                file.isNotEmpty && // Check if 'File' is not an empty string
                fileName.isNotEmpty &&
                title.isNotEmpty) {
              // Add the user to the list
              UserData user = UserData(
                studentID: studentID,
                matric: matric,
                name: name,
                svemail: svemail,
                monthlyReports: monthlyReports,
                finalReport: FinalReport(
                    date: date,
                    file: file,
                    fileName: fileName,
                    title: title,
                    status: status),
              );

              userData.add(user);
            }

            print('userData: $userData');
          }
        });
      }

      setState(() {});
    } catch (error) {
      print('Error fetching data: $error');
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

  Widget _status({required String status}) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            status,
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
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
          'Final Report Status',
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
                                        studentID: userData[index].studentID,
                                        name: userData[index].name,
                                        matric: userData[index].matric,
                                      ),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(1),
                                  title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: _name(
                                                name: userData[index].name)),
                                        Expanded(
                                          child: _status(
                                              status: userData[index]
                                                  .finalReport
                                                  .status),
                                        )
                                      ]),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 3),
                                      _matricNo(
                                          matricNo: userData[index].matric),
                                    ],
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
    );
  }
}
