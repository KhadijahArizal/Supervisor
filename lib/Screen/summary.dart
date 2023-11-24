import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/BottomNavBar/googleNavBar.dart';
import 'package:supervisor/Screen/StudentList/studentName.dart';
import 'package:supervisor/SideNavBar/sideNav.dart';

class Summary extends StatefulWidget {
  const Summary({super.key, required this.title}); //required this.totalStudents
  final String title;
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  Widget _smallRect({required String profile}) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(profile),
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

  int _totalStudents() {
    return allUsers.length;
  }

  Widget _totalS() {
    return Stack(children: [
      Container(
          alignment: Alignment.center,
          height: 150,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(148, 112, 18, 1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black)],
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '${_totalStudents()}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Futura',
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ))
              ])),
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
    return Stack(children: [
      Container(
          alignment: Alignment.center,
          height: 150,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(148, 112, 18, 1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black)],
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'TOTAL',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Futura',
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ))
              ])),
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
                    'Total Monthly Reports',
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

  int _currentIndex = 0; // Add this variable to track the current tab index
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
          color: Color.fromRGBO(148, 112, 18, 1),
          size: 30,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.sort,
                  color: Color.fromRGBO(148, 112, 18, 1), size: 30),
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
                Column(
                  children: [
                    Container(
                      child: Row(
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
                                  _name(name: 'Fatni Mufid'),
                                  const SizedBox(height: 5),
                                  _company(
                                      company: 'Petronas',
                                      icon: Icons.business),
                                ]),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _smallRect(
                                  profile: 'assets/profile.jpg',
                                ),
                              ],
                            ),
                          ]),
                    ),
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
                              BoxShadow(color: Color.fromRGBO(148, 112, 18, 1))
                            ],
                            border: Border.all(
                                color: const Color.fromRGBO(148, 112, 18, 1),
                                width: 7)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _superviorContact(
                                email: 'fatni.mufit@gmail.com',
                                supervisorID: 'SV0001'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                    ]),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: _totalS(),
                          ),
                          Expanded(
                            child: _totalM(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
