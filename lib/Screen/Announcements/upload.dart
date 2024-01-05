// ignore_for_file: non_constant_identifier_names

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/Screen/Announcements/thisUpload.dart';
import 'package:supervisor/Screen/data.dart';

class Upload extends StatefulWidget {
  const Upload({super.key, this.onFileSelected});

  final void Function(String fileName)? onFileSelected;

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController title = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController informationController = TextEditingController();
  late TextEditingController announcmentFileName;
  String selectedAnnouncFile = '';
  bool _isUploading = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Data announcProvider = Provider.of<Data>(context, listen: false);
    selectedAnnouncFile = '';
    announcmentFileName = TextEditingController(text: "-");
    title = TextEditingController(text: "-");
    announcProvider.date.text = DateFormat('dd MMMM yyyy').format(selectedDate);
    informationController = TextEditingController(text: "-");
  }

  Widget _File({
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.file_present_rounded,
          size: 28, color: Color.fromRGBO(148, 112, 18, 1)),
    );
  }

  void _pickFile() async {
    try {
      setState(() {
        _isUploading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.isNotEmpty) {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          String userId = user.uid;

          // Upload file to Firebase Storage
          String fileName = result.files.single.name;
          Reference storageReference = firebase_storage.FirebaseStorage.instance
              .ref('Announcements/$userId/$selectedDate $fileName');
          UploadTask uploadTask =
              storageReference.putData(result.files.single.bytes!);
          await uploadTask.whenComplete(() async {
            // Retrieve download URL
            String fileDownloadURL = await storageReference.getDownloadURL();

            // Update selected file name
            setState(() {
              announcmentFileName.text = fileName;
              selectedAnnouncFile = fileDownloadURL;
              _isUploading = false;
            });
          });
        }
      } else {
        print("File picking canceled");
        setState(() {
          _isUploading =
              false; // Set loading state to false if picking is canceled
        });
      }
    } catch (e) {
      // Handle exceptions
      print("Error picking/uploading file: $e");
      setState(() {
        _isUploading =
            false; // Set loading state to false if picking is canceled
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: const Text(
          'Upload Announcement',
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
      ),
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
                Colors.white30.withOpacity(0.2),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child:
                    Consumer<Data>(builder: (context, announcProvider, child) {
                  return Column(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Title',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontFamily: 'Futura'),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: announcProvider.title,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                fillColor: Colors.grey[100],
                                filled: true,
                                hintText: 'title',
                                prefixIcon: const Icon(Icons.person_rounded),
                              ),
                            )
                          ]),
                      const SizedBox(height: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontFamily: 'Futura'),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: announcProvider.date,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                fillColor: Colors.grey[100],
                                filled: true,
                                prefixIcon:
                                    const Icon(Icons.date_range_rounded),
                              ),
                              readOnly: true,
                            ),
                          ]),
                      const SizedBox(height: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Media',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontFamily: 'Futura'),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _File(onTap: _pickFile),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'Attach File',
                                    style: TextStyle(
                                        color: Color.fromRGBO(148, 112, 18, 1),
                                        fontSize: 17,
                                        fontFamily: 'Futura'),
                                    textAlign: TextAlign.right,
                                  ),
                                  if (_isUploading)
                                    const CircularProgressIndicator(),
                                ]),
                            const SizedBox(height: 10),
                            Text(
                              announcProvider.announcmentFileName.text.isNotEmpty
                                  ? 'Selected File: ${announcmentFileName.text}'
                                  : '',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontFamily: 'Futura',
                              ),
                            ),
                          ]),
                      const SizedBox(height: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Information',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontFamily: 'Futura')),
                            Container(
                                padding: const EdgeInsets.only(top: 5),
                                height: 150,
                                child: TextFormField(
                                  controller:
                                      announcProvider.informationController,
                                  expands: true,
                                  maxLines: null,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                  ),
                                )),
                          ]),
                      const SizedBox(height: 40),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            User? user = FirebaseAuth.instance.currentUser;
                            announcProvider.announcmentFileName.text =
                                announcmentFileName.text;

                            ThisUpload newUpload = ThisUpload(
                                title: announcProvider.title.text,
                                info:
                                    announcProvider.informationController.text,
                                fileName:
                                    announcProvider.announcmentFileName.text,
                                file: selectedAnnouncFile,
                                date: announcProvider.date.text);

                            if (user != null) {
                              String userId = user.uid;

                              DatabaseReference userRef = FirebaseDatabase
                                  .instance
                                  .ref('Supervisor')
                                  .child('Announcements')
                                  .child(userId)
                                  .push();

                              userRef.set({
                                'Sender': '${user.displayName}',
                                'Supervisor ID': userId,
                                'Announcement Title': announcProvider.title.text,
                                'File Name':
                                    announcProvider.announcmentFileName.text,
                                'File': selectedAnnouncFile,
                                'Date': announcProvider.date.text,
                                'Information':
                                    announcProvider.informationController.text
                              });

                              // Use the Data instance provided by the Consumer to update the announcements list
                              Provider.of<Data>(context, listen: false)
                                  .addAnnounc(newUpload);

                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(148, 112, 18, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0), // Adjust the radius as needed
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 25.0,
                            ),
                          ),
                          child: const Text("Upload",
                              style:
                                  TextStyle(color: Colors.white)), // Label text
                        ),
                      ),
                    ],
                  );
                })),
          ),
        ),
      ),
    );
  }
}
