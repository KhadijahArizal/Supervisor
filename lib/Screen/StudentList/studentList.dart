import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/BottomNavBar/googleNavBar.dart';
import 'package:supervisor/Screen/StudentList/studentDetails.dart';
import 'package:supervisor/Screen/StudentList/studentName.dart';
import 'package:supervisor/SideNavBar/sideNav.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key, required this.title});
  final String title;
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  Widget _name({required String name}) => Container(
        child: Column(
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
        ),
      );

  Widget _matricNo({required String matricNo}) => Container(
        child: Column(
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
        ),
      );

  final List<Map<String, dynamic>> _allUsers = allUsers;
  List<Map<String, dynamic>> _foundUsers = [];
  @override
  void initState() {
    _foundUsers = _allUsers;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) => user["matricNo"]
              .toString()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundUsers = results;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
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
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) => _runFilter(value),
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
                    child: _foundUsers.isNotEmpty
                        ? ListView.separated(
                            itemCount: _foundUsers.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                // Navigate to StudentDetails and pass the student's name
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentDetails(
                                      title: 'Student Details',
                                      studentName: _foundUsers[index]['name'], Matric: _foundUsers[index]["matricNo"],status: _foundUsers[index]
                                                    ["status"],
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(1),
                                title: _name(name: _foundUsers[index]['name']),
                                subtitle: _matricNo(
                                    matricNo: _foundUsers[index]["matricNo"],),
                              ),
                            ),
                            separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.black26,
                            ),
                          )
                        : const Text(
                            'No results found. Please insert the correct name.',
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                ],
              )),
        ),
      ),
      bottomNavigationBar: GNavbar(
        currentIndex: _currentIndex,
        onTabChange: onTabTapped,
      ),
    );
  }
}
