import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/Screen/Profile/EditProfilePage.dart';
import 'package:supervisor/Service/auth_service.dart';
import 'package:supervisor/SideNavBar/sideNav.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
    ));

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {Key? key,
      this.supervisorName,
      this.supervisorEmail,
      this.supervisorID,
      this.companyName,
      this.phoneNo})
      : super(key: key);

  final String? supervisorName,
      supervisorEmail,
      supervisorID,
      companyName,
      phoneNo;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  //Profile Page
  late DatabaseReference _studentRef;
  late Future<List<UserData>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _studentRef =
          FirebaseDatabase.instance.ref('Supervisor').child('Supervisor Details');
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
            String name = value['Supervisor Name'] ?? '';
            String email = value['Email'] ?? '';
            String contact = value['Contact No'] ?? '';
            String company = value['Company'] ?? '';

            UserData user = UserData(
              userId: userId,
              name: name,
              email: email,
              company: company,
              contact: contact,
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

  Widget _name({required String name}) => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  Widget _buildDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildDetail2(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    AuthService authService = AuthService();
    String supervisorID = generateSupervisorID(user!);

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
            Navigator.pushNamed(context, '/summary');
          },
        ),
        title: const Text(
          'Profile',
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
      ),
      drawer: sideNav(),
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: const AssetImage('assets/iiumlogo.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white30.withOpacity(0.2), BlendMode.dstATop),
                ),
              ),
              child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            border: Border.all(
                                                width: 10,
                                                color: const Color.fromRGBO(
                                                    0, 146, 143, 10)),
                                            color: const Color.fromRGBO(
                                                0, 146, 143, 10)),
                                        child: Column(children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Stack(children: [
                                            Container(
                                              alignment: Alignment.topCenter,
                                              width: 130,
                                              height: 130,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 4,
                                                      color: Colors.white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        spreadRadius: 2,
                                                        blurRadius: 10,
                                                        color: Colors.black
                                                            .withOpacity(0.1))
                                                  ],
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          authService
                                                                  .currentUser
                                                                  ?.photoURL ??
                                                              ''))),
                                            ),
                                          ]),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      _name(
                                                          name:
                                                              '${user.displayName}'),
                                                    ]),
                                              ]),
                                        ]),
                                      ),
                                      const SizedBox(height: 30),
                                      Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: FutureBuilder<List<UserData>>(
                                            future: _userDataFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Container();
                                              } else if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'),
                                                );
                                              } else {
                                                var user =
                                                    snapshot.data?.isNotEmpty ==
                                                            true
                                                        ? snapshot.data![0]
                                                        : null;

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          _buildDetail(
                                                              'Name',
                                                              user?.name ??
                                                                  '-'),
                                                          _buildDetail2(
                                                              'Supevisor ID',
                                                              supervisorID),
                                                        ]),
                                                    Row(children: [
                                                      _buildDetail('Email',
                                                          user?.email ?? '-'),
                                                    ]),
                                                    Row(children: [
                                                      _buildDetail('Contact No',
                                                          user?.contact ?? '-'),
                                                    ]),
                                                    Row(children: [
                                                      _buildDetail(
                                                          'Company Name',
                                                          user?.company ?? '-'),
                                                    ]),
                                                    const SizedBox(height: 70),
                                                  ],
                                                );
                                              }
                                            },
                                          )),
                                      Row(children: [
                                        Expanded(
                                            child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const EditProfile(
                                                          name: '',
                                                          email: '',
                                                        )));
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      0, 146, 143, 10),
                                              minimumSize:
                                                  const Size.fromHeight(50)),
                                          child: const Text('Edit Profile',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        )),
                                      ])
                                    ]),
                              ),
                            ),
                          ),
                        ])),
              ])))),
    );
  }
}

class UserData {
  final String userId;
  final String name;
  final String email;
  final String company;
  final String contact;

  UserData({
    required this.userId,
    required this.name,
    required this.email,
    required this.company,
    required this.contact,
  });
}
