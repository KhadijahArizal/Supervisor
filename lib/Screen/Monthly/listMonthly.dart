import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/Screen/StudentList/studentDetails.dart';
import 'package:supervisor/SideNavBar/sideNav.dart';

class listOfStudentMonthly extends StatefulWidget {
  const listOfStudentMonthly({Key? key}) : super(key: key);

  @override
  State<listOfStudentMonthly> createState() => _listOfStudentMonthlyState();
}

class _listOfStudentMonthlyState extends State<listOfStudentMonthly> {
  late DatabaseReference _iapFormRef;
  late DatabaseReference _monthlyReport;
  late List<UserData> userData = [];
  List<MonthlyReport> monthlyReports = [];

  @override
  void initState() {
    super.initState();
    _iapFormRef =
        FirebaseDatabase.instance.ref().child('Student').child('IAP Form');
    _monthlyReport = FirebaseDatabase.instance
        .ref()
        .child('Student')
        .child('Monthly Report');
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DataSnapshot iapSnapshot =
          await _iapFormRef.once().then((event) => event.snapshot);
      DataSnapshot monthlyReportSnapshot =
          await _monthlyReport.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? iapData =
          iapSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? monthlyReportData =
          monthlyReportSnapshot.value as Map<dynamic, dynamic>?;

      if (iapData != null && monthlyReportData != null) {
        iapData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> &&
              monthlyReportData.containsKey(key)) {
            String matric = value['Matric'] ?? '';
            String name = value['Name'] ?? '';
            String studentID = iapData[key]['Student ID'] ?? '';

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

            UserData user = UserData(
              matric: matric,
              name: name,
              monthlyReports: monthlyReports,
              studentID: studentID,
            );

            userData.add(user);
            print('Matric: $matric');
            print('Name: $name');
            print('Monthly Reports: $monthlyReports');
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
      drawer: sideNav(),
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

class MonthlyReport {
  final String month;
  final String monthlyRname;
  final String status;
  final String date;
  final String monthlyFile;

  MonthlyReport({
    required this.month,
    required this.monthlyRname,
    required this.status,
    required this.date,
    required this.monthlyFile,
  });
}

class UserData {
  final String matric;
  final String name, studentID;
  final List<MonthlyReport> monthlyReports;

  UserData({
    required this.matric,
    required this.name,
    required this.monthlyReports,
    required this.studentID,
  });
}
