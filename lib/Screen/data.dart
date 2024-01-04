// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:supervisor/Screen/Announcements/thisUpload.dart';

class Data extends ChangeNotifier {
  //Announcements
  final List<ThisUpload> _announc = [];
  List<ThisUpload> get Announcs => _announc;
  void addAnnounc(ThisUpload newReport) {
    _announc.add(newReport);
    notifyListeners();
  }

  void removeAnnounc(ThisUpload report) async {
    Announcs.remove(report);

    //User? user = FirebaseAuth.instance.currentUser;

    DatabaseReference announcRef = FirebaseDatabase.instance
        .reference()
        .child('Supervisor')
        .child('Announcements')
        .child('userId');

    // Remove the report from Firebase
    await announcRef.remove();

    notifyListeners();
  }

  //late ThisUpload announcFile;
  TextEditingController title = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController informationController = TextEditingController();
  late TextEditingController announcmentFileName;
  String selectedAnnouncFile = ''; 
  DateTime selectedDate = DateTime.now();
  Data() {
    announcmentFileName = TextEditingController(text: "-");
  }
  @override
  void dispose() {
    // Dispose of the controller when the Data instance is disposed
    announcmentFileName.dispose();
    super.dispose();
  }

  //Profile
  TextEditingController contact = TextEditingController();
  TextEditingController compName = TextEditingController();
}
