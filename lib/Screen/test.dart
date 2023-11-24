import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class A extends StatefulWidget {
  @override
  _AState createState() => _AState();
}

class _AState extends State<A> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DropdownSearch Demo")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(4),
            children: <Widget>[
              Column(
                children: [
                  const Padding(padding: EdgeInsets.all(4)),
                  DropdownSearch<String>(
                    items: const [
                      'January',
                      'February',
                      'March',
                      'April',
                      'May',
                      'June',
                      'July',
                      'August',
                      'September',
                      'October',
                      'November',
                      'December',
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/Screen/StudentList/studentDetails.dart';
import 'package:supervisor/Screen/StudentList/studentName.dart';

class SMonthlyReport extends StatefulWidget {
  const SMonthlyReport({super.key, required this.title});
  final String title;
  @override
  _SMonthlyReportState createState() => _SMonthlyReportState();
}

class _SMonthlyReportState extends State<SMonthlyReport> {
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
          .where((user) => user["status"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundUsers = results;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              size: 25,
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87.withOpacity(0.7), // Use the specified color
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Monthly Report Status',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                fontFamily: 'Futura'),
          ),
          backgroundColor: Colors.white70,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: const IconThemeData(
            color: Color.fromRGBO(148, 112, 18, 1),
            size: 30,
          )),
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
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          DropdownSearch(
                            /*onChanged: (value) => _runFilter(value!),
                            items: const [
                              'Approved',
                              'Pending',
                            ],*/
                            
                          ),
                        ],
                      ),
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
                                      studentName: _foundUsers[index]['name'], Matric: _foundUsers[index]["matricNo"],
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(1),
                                title: _name(name: _foundUsers[index]['name']),
                                subtitle: _matricNo(
                                    matricNo: _foundUsers[index]["status"]),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 */
