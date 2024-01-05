// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/BottomNavBar/googleNavBar.dart';
import 'package:supervisor/Screen/FinalReport/listFinal.dart';
import 'package:supervisor/Screen/Monthly/listMonthly.dart';
import 'package:supervisor/Screen/Profile/profilePage.dart';
import 'package:supervisor/Screen/StudentList/studentList.dart';
import 'package:supervisor/Service/auth_service.dart';
import 'package:supervisor/SideNavBar/sideNav.dart';

class Summary extends StatefulWidget {
  const Summary({super.key, required this.title});
  final String title;
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  int currentFinalIndex = 0;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  //Profile Page
  late DatabaseReference _studentRef;
  late Future<List<UserDataS>> _userDataFuture;

  //Monthly
  late DatabaseReference _monthlyReportCountsRef;
  Map<String, int> monthlyReportCounts = {};

  //Monthly
  late DatabaseReference _finalReportCountsRef;
  Map<String, int> finalReportCounts = {};

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _studentRef = FirebaseDatabase.instance
          .ref('Supervisor')
          .child('Supervisor Details');
      _userDataFuture = _fetchUserData();
      _monthlyReportCountsRef = FirebaseDatabase.instance
          .ref()
          .child('Supervisor')
          .child('Total Monthly Report')
          .child(userId);
      _fetchMonthlyReportCounts();
      _finalReportCountsRef = FirebaseDatabase.instance
          .ref()
          .child('Supervisor')
          .child('Total Final Report')
          .child(userId);
      _fetchFinalReportCounts();
    }
  }

  Future<List<UserDataS>> _fetchUserData() async {
    List<UserDataS> userDataList = [];
    try {
      DataSnapshot studentSnapshot =
          await _studentRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? studentData =
          studentSnapshot.value as Map<dynamic, dynamic>?;

      if (studentData != null) {
        studentData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            String company = value['Company'] ?? '';

            UserDataS user = UserDataS(
              userId: userId,
              company: company,
            );
            userDataList.add(user);
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return userDataList;
  }

  String generateSupervisorID(User user) {
    String supervisorID = 'SV${user.uid.substring(0, 4)}';

    return supervisorID;
  }

  Future<void> _fetchFinalReportCounts() async {
    try {
      DataSnapshot snapshot =
          await _finalReportCountsRef.once().then((event) => event.snapshot);
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        // Update the local finalReportCounts map with the fetched data
        finalReportCounts = {
          'totalStudents': data['totalStudents'] ?? 0,
          'pendingCount': data['pendingCount'] ?? 0,
          'approvedCount': data['approvedCount'] ?? 0,
          'rejectedCount': data['rejectedCount'] ?? 0,
        };
      }

      setState(() {});
    } catch (error) {
      print('Error fetching monthly report counts: $error');
    }
  }

  Future<void> _fetchMonthlyReportCounts() async {
    try {
      DataSnapshot snapshot =
          await _monthlyReportCountsRef.once().then((event) => event.snapshot);
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        // Update the local monthlyReportCounts map with the fetched data
        monthlyReportCounts = {
          'totalStudents': data['totalStudents'] ?? 0,
          'pendingCount': data['pendingCount'] ?? 0,
          'approvedCount': data['approvedCount'] ?? 0,
          'rejectedCount': data['rejectedCount'] ?? 0,
        };
      }

      setState(() {});
    } catch (error) {
      print('Error fetching monthly report counts: $error');
    }
  }

  Widget _smallRect({
    required String profile,
    required VoidCallback profileTap,
  }) {
    return InkWell(
      onTap: profileTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(profile), // Use NetworkImage for URLs
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _name({required String name}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(color: Colors.black54, fontSize: 20),
            )
          ],
        ),
      );

  Widget _superviorContact(
          {required String supervisorID, required String email}) =>
      Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              supervisorID,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const VerticalDivider(
              color: Colors.white,
              width: 20,
            ),
            Text(
              email,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      );

  Widget _company({required String company, required IconData icon}) =>
      Container(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Text(
              company,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            )
          ],
        ),
      );

  void _handleForwardAction() {
    setState(() {
      if (currentFinalIndex < 1) {
        currentFinalIndex++;
      }
    });
  }

  int _currentIndex = 0;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex =
          index; // Update the current tab index when a tab is tapped
      if (index == 0) {
        Navigator.pushNamed(context, '/summary');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/student_list');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/announc');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    AuthService authService = AuthService();
    String supervisorID = generateSupervisorID(user!);
    // final Future<FirebaseApp> fApp = Firebase.initializeApp();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            'Supervisor Dashboard',
            style: TextStyle(
                color: Colors.black38, fontSize: 15, fontFamily: 'Futura'),
            textAlign: TextAlign.right,
          )
        ]),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome!',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 40,
                                      //fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Futura'),
                                ),
                                const SizedBox(width: 5),
                                _name(name: '${user.displayName}'),
                                const SizedBox(height: 5),
                                FutureBuilder<List<UserDataS>>(
                                  future: _userDataFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      );
                                    } else {
                                      var user =
                                          snapshot.data?.isNotEmpty == true
                                              ? snapshot.data![0]
                                              : null;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _company(
                                              company: user?.company ?? '-',
                                              icon: Icons.business),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ]),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _smallRect(
                                profile:
                                    authService.currentUser?.photoURL ?? '',
                                profileTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ProfilePage()));
                                },
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ]),
                    const SizedBox(
                      height: 5,
                    ),
                    Column(children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            boxShadow: const [
                              BoxShadow(color: Color.fromRGBO(0, 146, 143, 10))
                            ],
                            border: Border.all(
                                color: const Color.fromRGBO(0, 146, 143, 10),
                                width: 7)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _superviorContact(
                                email: '${user.email}',
                                supervisorID: supervisorID),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                    ]),
                    //PIE CHART
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: monthlyReportCounts.isNotEmpty
                                ? _buildPieChart()
                                : const Center(
                                    child: Text('No Monthly Report Submitted',
                                        style: TextStyle(fontSize: 15),
                                        textAlign: TextAlign.center),
                                  )),
                        const SizedBox(width: 8),
                        Expanded(
                            child: monthlyReportCounts.isNotEmpty
                                ? _buildPieChart2()
                                : const Center(
                                    child: Text('No Final Report Submitted',
                                        style: TextStyle(fontSize: 15),
                                        textAlign: TextAlign.center),
                                  )),
                      ],
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    //Total Students
                    Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StudentList(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(color: Colors.grey, blurRadius: 1.0)
                                ],
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    //headline
                                    const Text(
                                      'Total Students',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontFamily: 'Futura',
                                          fontWeight: FontWeight.w900),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                      thickness: 0.1,
                                    ),
                                    StreamBuilder(
                                      stream: FirebaseDatabase.instance
                                          .ref('Supervisor')
                                          .child('Total Student')
                                          .child(userId)
                                          .onValue,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          final Map<String, dynamic>? data =
                                              (snapshot.data?.snapshot.value
                                                  as Map<String, dynamic>?);

                                          final int totalStudents =
                                              data?['totalStudents'] ?? 0;

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                totalStudents.toString(),
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 146, 143, 10),
                                                  fontSize: 60,
                                                  fontFamily: 'Futura',
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                  ]),
                            )),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: GNavbar(
        currentIndex: _currentIndex,
        onTabChange: onTabTapped,
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
        height: 150, // Set an appropriate height for the container
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const listOfStudentMonthly(),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(child: Text('Monthly Report Submission')),
                      Expanded(
                        child: PieChart(PieChartData(
                          sections: _generatePieSections(),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 5,
                          centerSpaceRadius: 40,
                          centerSpaceColor: Colors.transparent,
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget _buildPieChart2() {
    return Container(
        height: 150, // Set an appropriate height for the container
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const listOfStudentFinal(),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(child: Text('Final Report Submission')),
                      Expanded(
                        child: PieChart(PieChartData(
                          sections: _generatePieSections2(),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 5,
                          centerSpaceRadius: 40,
                          centerSpaceColor: Colors.transparent,
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  List<PieChartSectionData> _generatePieSections() {
    int totalStudents = monthlyReportCounts['totalStudents'] ?? 0;
    int pendingCount = monthlyReportCounts['pendingCount'] ?? 0;
    int approvedCount = monthlyReportCounts['approvedCount'] ?? 0;
    int rejectedCount = monthlyReportCounts['rejectedCount'] ?? 0;

    return [
      PieChartSectionData(
        value: pendingCount.toDouble(),
        title:
            'Pending\n$pendingCount', // Display the label and number as a title
        color: Colors.yellow[700],
        showTitle: true,
      ),
      PieChartSectionData(
        value: approvedCount.toDouble(),
        title:
            'Approved\n$approvedCount', // Display the label and number as a title
        color: Colors.green[700],
        showTitle: true,
      ),
      PieChartSectionData(
        value: rejectedCount.toDouble(),
        title:
            'Rejected\n$rejectedCount', // Display the label and number as a title
        color: Colors.red[700],
        showTitle: true,
      ),
    ];
  }

  List<PieChartSectionData> _generatePieSections2() {
    int totalStudents = finalReportCounts['totalStudents'] ?? 0;
    int pendingCount = finalReportCounts['pendingCount'] ?? 0;
    int approvedCount = finalReportCounts['approvedCount'] ?? 0;
    int rejectedCount = finalReportCounts['rejectedCount'] ?? 0;

    return [
      PieChartSectionData(
        value: pendingCount.toDouble(),
        title:
            'Pending\n$pendingCount', // Display the label and number as a title
        color: Colors.yellow[700],
        showTitle: true,
      ),
      PieChartSectionData(
        value: approvedCount.toDouble(),
        title:
            'Approved\n$approvedCount', // Display the label and number as a title
        color: Colors.green[700],
        showTitle: true,
      ),
      PieChartSectionData(
        value: rejectedCount.toDouble(),
        title:
            'Rejected\n$rejectedCount', // Display the label and number as a title
        color: Colors.red[700],
        showTitle: true,
      ),
    ];
  }
}

class UserDataS {
  final String userId;
  final String company;

  UserDataS({
    required this.userId,
    required this.company,
  });
}
