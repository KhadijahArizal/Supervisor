// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/BottomNavBar/googleNavBar.dart';
import 'package:supervisor/Screen/data.dart';
import 'package:supervisor/Screen/Profile/profilePage.dart';
import 'package:supervisor/Service/auth_service.dart';
import 'package:supervisor/SideNavBar/sideNav.dart';

class Summary extends StatefulWidget {
  const Summary({super.key, required this.title, required this.totalStudents});
  final String title;
  final int totalStudents;
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  int currentFinalIndex = 0;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  //Profile Page
  late DatabaseReference _studentRef;
  late Future<List<UserData>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _studentRef = FirebaseDatabase.instance
          .ref('Supervisor')
          .child('Supervisor Details');
      _userDataFuture = _fetchUserData();
    }
  }

  Future<List<UserData>> _fetchUserData() async {
    List<UserData> userDataList = [];
    try {
      DataSnapshot studentSnapshot =
          await _studentRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? studentData =
          studentSnapshot.value as Map<dynamic, dynamic>?;

      if (studentData != null) {
        studentData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            String company = value['Company'] ?? '';

            UserData user = UserData(
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

  Widget _totalS() {
    return Stack(children: [
      Container(
          alignment: Alignment.center,
          height: 150,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 146, 143, 10),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black)],
          ),
          child: Container(
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'TEST', //'${_totalStudents()}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                    const Text(
                      'Total Students',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.totalStudents.toString(),
                      style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ]))),
      Align(
          alignment: Alignment.center,
          child: Container(
            height: 50,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 70),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 1)
              ],
            ),
            child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Students',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Futura',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                ]),
          ))
    ]);
  }

  Widget _totalM() {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          height: 150,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 146, 143, 10),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black)],
          ),
          child: Container(
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Column(
                          children: [
                            Text(
                              'Pending',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '',
                              //'${_totalPendingM()}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Column(
                          children: [
                            Text(
                              'Approved',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '',
                              //'${_totalApprovedM()}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 50,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 70),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, spreadRadius: 2, blurRadius: 1),
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total Monthly Reports',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Futura',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleBackAction() {
    setState(() {
      if (currentFinalIndex > 0) {
        currentFinalIndex--;
      }
    });
  }

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
          child: SingleChildScrollView(
            child: Stack(
              children: [
                /*FutureBuilder(
                        future: fApp,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('ERRORR');
                          } else if (snapshot.hasData) {
                            return const Text('YEAYY');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),*/
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
                                FutureBuilder<List<UserData>>(
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
                    /*Column(
                      children: [
                        Container(
                          child: _totalS(),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          child: _totalM(),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          child: _totalF(),
                        ),
                      ],
                    ),*/
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
}

class UserData {
  final String userId;
  final String company;

  UserData({
    required this.userId,
    required this.company,
  });
}
