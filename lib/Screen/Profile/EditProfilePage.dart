import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/Screen/data.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String email;

  const EditProfile({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    name.text = '${user?.displayName}';
    email.text = '${user?.email}';
  }

  @override
  Widget build(BuildContext context) {
    var svData = Provider.of<Data>(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
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
            color: Color.fromRGBO(0, 146, 143, 10), size: 30),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 25,
            color: Color.fromRGBO(0, 146, 143, 10), // Use the specified color
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                      Colors.white30.withOpacity(0.2), BlendMode.dstATop),
                ),
              ),
              child: SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Consumer<Data>(builder: (context, Data, child) {
                        return Column(
                          children: [
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextFormField(
                                    key: UniqueKey(),
                                    controller: name,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon: const Icon(Icons.person),
                                      labelText: 'Name',
                                    ),
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    key: UniqueKey(),
                                    controller: email,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon: const Icon(Icons.email),
                                      labelText: 'Email',
                                    ),
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    key: UniqueKey(),
                                    controller: svData.contact,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon:
                                          const Icon(Icons.phone_rounded),
                                      labelText: 'Phone No',
                                      hintText: 'Start with your country code. Ex, +62, +60'
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    key: UniqueKey(),
                                    controller: svData.compName,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon: const Icon(Icons.business),
                                      labelText: 'Company Name',
                                    ),
                                  ),
                                  const SizedBox(height: 16)
                                ]),
                            Container(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                          child: ElevatedButton(
                                        onPressed: () {
                                          print('Name: ${name.text}');
                                          print('Email: ${email.text}');
                                          print(
                                              'Contact: ${svData.contact.text}');
                                          print(
                                              'Company Name: ${svData.compName.text}');
                                          User? user =
                                              FirebaseAuth.instance.currentUser;

                                          if (user != null) {
                                            String userId = user.uid;
                                            DatabaseReference userRef =
                                                FirebaseDatabase.instance
                                                    .ref('Supervisor')
                                                    .child('Supervisor Details')
                                                    .child(userId);

                                            userRef.set({
                                              'Supervisor Name': name.text,
                                              'Email': email.text,
                                              'Contact No': svData.contact.text,
                                              'Company': svData.compName.text,
                                            }).then((_) {
                                              Navigator.pushNamed(
                                                  context, '/profile');
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    0, 146, 143, 10),
                                            minimumSize:
                                                const Size.fromHeight(50)),
                                        child: const Text('Save',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ))
                                    ]))
                          ],
                        );
                      }))))),
    );
  }
}
