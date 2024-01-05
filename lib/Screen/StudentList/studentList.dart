import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/BottomNavBar/googleNavBar.dart';
import 'package:supervisor/Screen/StudentList/studentDetails.dart';
import 'package:supervisor/Screen/common/models.dart';
import 'package:supervisor/SideNavBar/sideNav.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  User? user = FirebaseAuth.instance.currentUser;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late List<UserDataS> originalUserData = []; // Store the unfiltered data
  late List<UserDataS> userData = []; // Store the filtered data
  late DatabaseReference _iapFormRef;
  late DatabaseReference _totalStudentsRef;
  late DatabaseReference _supervisorRef;

  @override
  void initState() {
    super.initState();
    _supervisorRef =
        FirebaseDatabase.instance.ref('Student').child('Supervisor Details');
    _iapFormRef =
        FirebaseDatabase.instance.ref().child('Student').child('IAP Form');
    _totalStudentsRef = FirebaseDatabase.instance
        .ref('Supervisor')
        .child('Total Student')
        .child(userId);
    _fetchTotalStudents(); // Fetch total students separately
    _fetchUserData(); // Fetch user data for displaying the list
  }

  Future<void> _fetchUserData() async {
    try {
      String supervisorEmail = '${user?.email}';
      DataSnapshot iapSnapshot =
          await _iapFormRef.once().then((event) => event.snapshot);
      DataSnapshot svReportSnapshot =
          await _supervisorRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? iapData =
          iapSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? svReportData =
          svReportSnapshot.value as Map<dynamic, dynamic>?;

      if (iapData != null && svReportData != null) {
        svReportData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && iapData.containsKey(key)) {
            String matric = iapData[key]['Matric'] ?? '';
            String name = iapData[key]['Name'] ?? '';
            String studentID = iapData[key]['Student ID'] ?? '';
            String svemail = svReportData[key]['Email'] ?? '';

            if (svemail == supervisorEmail) {
              UserDataS user = UserDataS(
                studentID: studentID,
                matric: matric,
                name: name,
                svemail: svemail,
              );
              userData.add(user);
              originalUserData.add(user);
              /* print(
                  'Skipping student with key: $key. Supervisor email does not match: $svemail = $supervisorEmail');
                  print('Skipping student with key: $key. Invalid data structure.');*/
            }
          }
        });
      }
      setState(() {});
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> _fetchTotalStudents() async {
    try {
      DataSnapshot iapSnapshot =
          await _iapFormRef.once().then((event) => event.snapshot);
      DataSnapshot svReportSnapshot =
          await _supervisorRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? iapData =
          iapSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? svReportData =
          svReportSnapshot.value as Map<dynamic, dynamic>?;

      int totalStudents = 0;

      if (iapData != null && svReportData != null) {
        svReportData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && iapData.containsKey(key)) {
            String svemail = svReportData[key]['Email'] ?? '';
            if (svemail == '${user?.email}') {
              totalStudents++;
            }
          }
        });
      }

      // Save total students to the database
      await _totalStudentsRef.set({'totalStudents': totalStudents});
    } catch (error) {
      print('Error fetching total students: $error');
    }
  }

  List<UserDataS> _filterUserData(String searchValue) {
    return userData
        .where((user) =>
            user.matric.toLowerCase().contains(searchValue.toLowerCase()) &&
            user.studentID
                .isNotEmpty) // Filter out entries with empty studentID
        .toList();
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
                              userData = [
                                UserDataS(
                                  name: 'No student found',
                                  matric: '',
                                  studentID: '',
                                  svemail: '',
                                ),
                              ];
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
