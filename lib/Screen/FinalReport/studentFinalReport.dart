import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/Screen/FinalReport/studentNameFinal.dart';
import 'package:supervisor/Screen/StudentList/studentDetails.dart';

class SFinalReport extends StatefulWidget {
  const SFinalReport({super.key, required this.title});
  final String title;
  @override
  _SFinalReportState createState() => _SFinalReportState();
}

class _SFinalReportState extends State<SFinalReport>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final List<Map<String, dynamic>> _allUsersF = allUsersF;
  List<Map<String, dynamic>> _foundUsers = [];

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    _runFilter('');

    tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (tabController.indexIsChanging) {
      return;
    }

    if (tabController.index >= 0 && tabController.index < 2) {
      _runFilter('');
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _runFilter(String text) {
    setState(() {
      if (tabController.index == 0) {
        // Pending tab is selected, filter pending students
        _foundUsers = _allUsersF
            .where(
                (user) => user["status"].toString().toLowerCase() == 'pending')
            .toList();
      } else {
        // Approved tab is selected, filter approved students
        _foundUsers = _allUsersF
            .where(
                (user) => user["status"].toString().toLowerCase() == 'approved')
            .toList();
      }
    });
  }

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

  Widget _status({required String status}) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontFamily: 'Futura',
              ),
            )
          ],
        ),
      );

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
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child:
                            Column(mainAxisSize: MainAxisSize.max, children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(
                                    width: 10,
                                    color:
                                        const Color.fromRGBO(148, 112, 18, 1)),
                                color: const Color.fromRGBO(148, 112, 18, 1)),
                            child: Column(children: [
                              DefaultTabController(
                                length: 2,
                                child: TabBar(
                                  unselectedLabelColor: Colors.white,
                                  labelColor:
                                      const Color.fromRGBO(148, 112, 18, 1),
                                  indicatorColor: Colors.white,
                                  indicatorWeight: 0.0,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  controller: tabController,
                                  tabs: const [
                                    Tab(text: ' Pending'),
                                    Tab(
                                      text: 'Approved',
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          Expanded(
                              child: TabBarView(
                            controller: tabController,
                            children: [
                              // Approved Tab
                              _foundUsers.isNotEmpty
                                  ? ListView.separated(
                                      itemCount: _foundUsers.length,
                                      itemBuilder: (context, index) =>
                                          GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentDetails(
                                                title: 'Student Details',
                                                studentName: _foundUsers[index]
                                                    ['name'],
                                                Matric: _foundUsers[index]
                                                    ["matricNo"],
                                                status: _foundUsers[index]
                                                    ["status"],
                                                onStatusChanged: (String) {},
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              8.0), // Add your desired padding
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(1),
                                            title: _name(
                                                name: _foundUsers[index]
                                                    ['name']),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _matricNo(
                                                    matricNo: _foundUsers[index]
                                                        ["matricNo"]),
                                                _status(
                                                    status: _foundUsers[index]
                                                        ["status"]),
                                              ],
                                            ),
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
                                      'No approved results found. Please insert the correct name.',
                                      style: TextStyle(fontSize: 20),
                                    ),

                              // Pending Tab
                              _foundUsers.isNotEmpty
                                  ? ListView.separated(
                                      itemCount: _foundUsers.length,
                                      itemBuilder: (context, index) =>
                                          GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentDetails(
                                                title: 'Student Details',
                                                studentName: _foundUsers[index]
                                                    ['name'],
                                                Matric: _foundUsers[index]
                                                    ["matricNo"],
                                                status: _foundUsers[index]
                                                    ["status"],
                                                onStatusChanged: (String) {},
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              8.0), // Add your desired padding
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(1),
                                            title: _name(
                                                name: _foundUsers[index]
                                                    ['name']),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _matricNo(
                                                    matricNo: _foundUsers[index]
                                                        ["matricNo"]),
                                                _status(
                                                    status: _foundUsers[index]
                                                        ["status"]),
                                              ],
                                            ),
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
                                      'No pending results found. Please insert the correct name.',
                                      style: TextStyle(fontSize: 20),
                                    ),
                            ],
                          ))
                        ]),
                      ),
                    )
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
